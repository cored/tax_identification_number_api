require 'rails_helper'

RSpec.describe TaxNumberIdentifications::CA do
  subject(:tin_ca) { described_class }

  describe '.from' do
    context 'when the TIN is valid' do
      it 'returns formatted TIN NNNNNNNNNRT00001' do
        expect(tin_ca.from('123456789RT00001').tin).to eq('123456789RT00001')
      end
    end

    context 'when the TIN is invalid' do
      it 'returns an error message' do
        expect { tin_ca.from('AAA1234567890') }.to raise_error('invalid tin, correct TIN format NNNNNNNNNRTNNNNN')
      end
    end
  end

end
