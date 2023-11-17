require "rails_helper"

RSpec.describe LoanInsurance::GroupRemit, type: :model do
  let(:group_remit) { create(:group_remit) }

  describe "A valid Loan Isurance Remittance" do
    it "is valid with valid attributes" do
      expect(group_remit).to be_valid
    end

    it "is not valid if type is not LoanInsurance::GroupRemit" do
      group_remit.type = "AnotherType"
      expect(group_remit).not_to be_valid
      expect(group_remit.errors[:type]).to include("is not valid")
    end

    it "is valid if type is LoanInsurance::GroupRemit" do
      group_remit.type = "LoanInsurance::GroupRemit"
      expect(group_remit).to be_valid
    end

    it "is not valid without a name" do
      group_remit.name = nil
      expect(group_remit).not_to be_valid
      expect(group_remit.errors[:name]).to include("can't be blank")
    end

    it "is not valid without an agreement_id" do
      group_remit.agreement_id = nil
      expect(group_remit).not_to be_valid
    end
  end

end
