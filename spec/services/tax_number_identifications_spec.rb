require 'rails_helper'

RSpec.describe TaxNumberIdentifications do
  subject(:tax_number_identifications) { described_class }
  let(:tin_params) { { country: country, tin: tin } }

  describe '.for' do
    context 'when supported country' do
      context 'when valid tin' do
        let(:country) { 'AU' }
        let(:tin) { '345678901' }

        it 'returns formatted TIN' do
          expect(tax_number_identifications.for(tin_params).to_h).to eql(tin: '345 678 901')
        end
      end

      context 'when invalid tin' do
        let(:country) { 'AU' }
        let(:tin) { 'A234567' }

        it 'raises an InvalidTIN error' do
          expect { tax_number_identifications.for(tin_params) }.to raise_error(TaxNumberIdentifications::InvalidTIN)
        end

      end
    end

    context 'when unsupported country' do
      let(:country) { 'US' }
      let(:tin) { '123456789' }

      it 'raises an error' do
        expect { tax_number_identifications.for(tin_params) }.to raise_error(TaxNumberIdentifications::UnsupportedCountry)
      end

      it 'returns an error message' do
        expect { tax_number_identifications.for(tin_params) }.to raise_error('unsupported country US')
      end
    end
  end
end
