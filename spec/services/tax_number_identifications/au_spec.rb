require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AU do
  subject(:tin_au) { described_class }

  describe '.from' do
    context 'when the TIN is valid' do
      it 'returns the correct formatted TIN' do
        expect(tin_au.from('51824753556').tin).to eq('51 824 753 556')
      end
    end

    context 'when the TIN is invalid' do
      it 'raises an error message' do
        expect { tin_au.from('A234567890') }.to raise_error('invalid tin, correct TIN format NNNNNNNNN')
      end
    end
  end
end
