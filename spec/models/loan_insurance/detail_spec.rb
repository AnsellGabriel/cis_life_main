require 'rails_helper'

RSpec.describe LoanInsurance::Detail, type: :model do
  let(:detail) { create(:detail) }

  describe 'A valid loan detail' do
    it 'will create a new loan detail with valid attributes' do
      expect(detail).to be_valid
      expect(detail).to be_an_instance_of(LoanInsurance::Detail)
    end

  end
end
