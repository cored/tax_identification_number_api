require 'rails_helper'

RSpec.describe TaxNumberIdentifications::ABN do
  subject(:tin_abn) { described_class }

  describe '.from' do
    context 'when the TIN is valid' do
      it 'returns formatted TIN NN NNN NNN NNN' do
        expect(tin_abn.from('51824753556').tin).to eq('51 824 753 556')
      end
    end

    context 'when the TIN is invalid' do
      it 'raises an error message' do
        expect { tin_abn.from('A234567890') }.to raise_error('invalid tin, correct TIN format NNNNNNNNNNN')
      end
    end
  end
end
