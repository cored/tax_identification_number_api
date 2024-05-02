require 'rails_helper'

RSpec.describe TaxNumberIdentifications::AU do
  subject(:tin_au) { described_class }

  describe '.from' do
    context 'when the TIN is au_abn' do
      it 'returns formatted TIN NN NNN NNN NNN' do
        expect(tin_au.from('12345678901').tin).to eq('12 345 678 901')
      end
    end

    context 'when the TIN is au_acn' do
      it 'returns formatted TIN NNN NNN NNN' do
        expect(tin_au.from('123456789').tin).to eq('123 456 789')
      end
    end

    context 'when the TIN is invalid' do
      it 'raises an error message' do
        expect { tin_au.from('A234567890') }.to raise_error('invalid tin, correct TIN format NNNNNNNNN or NNNNNNNNNNN')
      end
    end
  end
end
