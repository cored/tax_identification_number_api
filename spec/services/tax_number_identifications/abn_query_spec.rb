require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AbnQuery do
	let(:http_client) { double("http_client") }
	let(:abn) { TaxNumberIdentifications::ABN.new(tin: "1234567890") }
	let(:response_body) do
		<<-XML
		<businessEntity>
			<abn>1234567890</abn>
			<status>Active</status>
			<entityType>Company</entityType>
			<organisationName>Test Company</organisationName>
			<goodsAndServicesTax>true</goodsAndServicesTax>
			<effectiveTo>2024-12-31</effectiveTo>
			<address>
				<stateCode>NSW</stateCode>
				<postcode>2000</postcode>
			</address>
		</businessEntity>
		XML
	end
	let(:response) { double("response", body: response_body) }

	subject(:abn_query) { described_class.new(http_client: http_client) }

	before do
		allow(http_client).to receive(:get).and_return(response)
	end

	describe ".call" do
		context "when ABN is registered for GST" do
			it "returns parsed response" do
				expect(abn_query.call(abn).to_h).to match(
					abn: "1234567890",
					status: "Active",
					entity_type: "Company",
					organisation_name: "Test Company",
					goods_and_services_tax: true,
					effective_to: "2024-12-31",
					address: {
						state_code: "NSW",
						postcode: "2000"
					}
				)
			end
		end

		context "when ABN is not registered for GST" do
			let(:response_body) do
				<<-XML
				<businessEntity>
					<abn>1234567890</abn>
					<status>Active</status>
					<entityType>Company</entityType>
					<organisationName>Test Company</organisationName>
					<goodsAndServicesTax>false</goodsAndServicesTax>
					<effectiveTo>2024-12-31</effectiveTo>
					<address>
						<stateCode>NSW</stateCode>
						<postcode>2000</postcode>
					</address>
				</businessEntity>
				XML
			end

			it "raises an InvalidTIN error" do
				expect { abn_query.call(abn) }.to raise_error(TaxNumberIdentifications::InvalidTIN, "ABN is not registered for GST")
			end
		end
	end
end
