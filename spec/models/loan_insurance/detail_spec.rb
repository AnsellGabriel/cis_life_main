require 'rails_helper'

RSpec.describe LoanInsurance::Detail, type: :model do
  let(:detail) { create(:detail) }

  describe 'A valid loan detail' do
    it 'will create a new loan detail with valid attributes' do
      expect(detail).to be_valid
      expect(detail).to be_an_instance_of(LoanInsurance::Detail)
    end

    it "is not valid without a loan" do
      detail.loan = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a batch" do
      detail.batch = nil
      expect(detail).to_not be_valid
    end

    it "is not valid if it's batch type is not LoanInsurance::Batch" do
      detail.batch.type = 'LoanInsurance::NotBatch'
      expect(detail).to_not be_valid
    end

    it "is not valid without a rate" do
      detail.rate = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a loan amount" do 
      detail.loan_amount = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a premium" do
      detail.premium = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a term" do
      detail.term = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a date release" do
      detail.date_release = nil
      expect(detail).to_not be_valid
    end

    it "is not valid without a date maturity" do
      detail.date_maturity = nil
      expect(detail).to_not be_valid
    end

  end
end
