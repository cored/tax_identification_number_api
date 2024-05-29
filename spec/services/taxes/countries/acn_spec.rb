require 'rails_helper'

RSpec.describe Taxes::Countries::ACN do
  subject(:tin_acn) { described_class }

  describe '.from' do
    context 'when the TIN is valid' do
      it 'returns formatted TIN NNNNNNNNN' do
        expect(tin_acn.from('123456789').tin).to eq('123 456 789')
      end
    end

    context 'when the TIN is invalid' do
      it 'returns an error message' do
        expect { tin_acn.from('A234567890') }.to raise_error('invalid tin, correct TIN format NNNNNNNNN')
      end
    end
  end
end
