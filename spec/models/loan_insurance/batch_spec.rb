require 'rails_helper'

RSpec.describe LoanInsurance::Batch, type: :model do
  let(:batch) { create(:batch) }

  describe "A valid batch" do
    it "will create a new batch with valid attributes" do
      expect(batch).to be_valid
      expect(batch).to be_an_instance_of(LoanInsurance::Batch)
    end

    it "is not valid without an effectivity date" do
      batch.effectivity_date = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without an expiry date" do
      batch.expiry_date = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without coop_sf_amount" do
      batch.coop_sf_amount = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without agent_sf_amount" do
      batch.agent_sf_amount = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without premium" do
      batch.premium = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without a coop_member_id" do 
      batch.coop_member_id = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without an agreement_benefit_id" do
      batch.agreement_benefit_id = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without an age" do 
      batch.age = nil
      expect(batch).not_to be_valid
    end

    context 'filter batch' do
      it 'is valid if age is within agreement\'s age range'

      it 'is not valid if age is not within agreement\'s age range' 

    end
  end
end
