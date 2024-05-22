require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AU do
  subject(:tin_au) { described_class.from(tin, abn_query: abn_query) }
  let(:abn_query) { class_double(TaxNumberIdentifications::AbnQuery, call: abn_query_response) }
  let(:abn_query_response) do
    TaxNumberIdentifications::AbnQuery::Response.new(
      abn: '51824753556',
      status: 'Active',
      entity_type: 'Company',
      organisation_name: 'Example Company Pty Ltd',
      goods_and_services_tax: true,
      effective_to: '2025-04-01',
      address: {
        state_code: 'NSW',
        postcode: '2000'
      }
    )
  end

  describe '.from' do
    context 'when the TIN is ACN' do
      let(:tin) { '824753556' }

      it 'returns the correct TIN' do
        expect(tin_au.tin).to eq('824 753 556')
      end
    end

    context 'when the TIN is ABN' do
      let(:tin) { '51824753556' }

      it 'returns the correct TIN' do
        expect(tin_au.tin).to eq('51 824 753 556')
      end
    end

    context 'when the TIN is invalid' do
      let(:tin) { '789' }

      it 'raises an error message' do
        expect { tin_au }.to raise_error(TaxNumberIdentifications::InvalidTIN)
      end
    end
  end
end
