require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AU do
  subject(:tin_au) { described_class.from(tin) }

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
