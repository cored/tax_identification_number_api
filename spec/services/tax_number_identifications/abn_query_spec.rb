require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AbnQuery do
	let(:abn) { TaxNumberIdentifications::ABN.new(tin: "51824753556") }

	subject(:abn_query) { described_class }

	describe ".call" do
		context "when ABN is registered for GST", :vcr do
			it "returns parsed response" do
				expect(abn_query.call(abn).to_h).to match(
					abn: "51824753556",
					status: "Active",
					entity_type: "Company",
					organisation_name: "Example Company Pty Ltd",
					goods_and_services_tax: true,
					effective_to: "2025-04-01",
					address: {
						state_code: "NSW",
						postcode: "2000"
					}
				)
			end
		end

		context "when ABN is not registered for GST", :vcr do
			let(:abn) { TaxNumberIdentifications::ABN.new(tin: "51824753557") }

			it "raises an InvalidTIN error" do
				expect { abn_query.call(abn) }.to raise_error(TaxNumberIdentifications::InvalidTIN, "ABN is not registered for GST")
			end
		end
	end
end
