require 'rails_helper'

RSpec.describe TaxNumberIdentifications::IN do
  subject(:tin_in) { described_class }

  describe '.from' do
    context 'when the TIN is valid' do
      it 'returns formatted NNXXXXXXXXXXNAN' do
        expect(tin_in.from('22AAAA0000A1Z5').tin).to eq('22AAAA0000A1Z5')
      end
    end

    context 'when the TIN is invalid' do
      it 'returns an error message' do
        expect { tin_in.from('AAA1234567890') }.to raise_error('invalid tin, correct TIN format NNXXXXXXXXXXNAN')
      end
    end
  end
end
