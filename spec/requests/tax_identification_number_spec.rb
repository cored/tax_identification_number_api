require 'rails_helper'

RSpec.describe "TaxIdentificationNumbers", type: :request do
  describe "POST /create" do
    context "when country and tin are valid" do
      it "returns http success" do
        post "/tax_identification_numbers", params: { country: "AU", tin: "51824753556" }
        expect(response).to have_http_status(:success)
      end

      it "returns weather the TIN is valid" do
        post "/tax_identification_numbers", params: { country: "AU", tin: "51824753556" }
        expect(response.body).to eq({ success: true, tin: "51 824 753 556" }.to_json)
      end

      it "returns a formatted TIN according to the country requirements" do
        post "/tax_identification_numbers", params: { country: "AU", tin: "51824753556" }
        expect(response.body).to eq({ success: true, tin: "51 824 753 556" }.to_json)

      end
    end

    context "when country is not supported" do
      it "returns http not found" do
        post "/tax_identification_numbers", params: { country: "US", tin: "123456789" }
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        post "/tax_identification_numbers", params: { country: "US", tin: "123456789" }
        expect(response.body).to eq({ error: "unsupported country US" }.to_json)
      end
    end

    context 'when the TIN is invalid' do
      it 'returns http unprocessable entity' do
        post "/tax_identification_numbers", params: { country: "AU", tin: "789" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post "/tax_identification_numbers", params: { country: "AU", tin: "789" }
        expect(response.body).to eq({ error: "invalid tin, correct TIN format NNNNNNNNN" }.to_json)
      end
    end
  end
end
