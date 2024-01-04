require "rails_helper"

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

    it "is not valid without a date realease" do
      batch.date_release = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without a date mature" do
      batch.date_mature = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without coop service fee" do
      batch.coop_sf_amount = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without agent service fee" do
      batch.agent_sf_amount = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without premium" do
      batch.premium = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without an age" do
      batch.age = nil
      expect(batch).not_to be_valid
    end

    it "is not valid without an insurance status" do
      batch.insurance_status = nil
      expect(batch).not_to be_valid
    end

    context "with associations" do
      it "is not valid without a coop member" do
        batch.coop_member = nil
        expect(batch).not_to be_valid
      end

      it "is not valid without group remit" do
        batch.group_remit = nil
        expect(batch).not_to be_valid
      end

      it "is not valid without loan" do
        batch.loan = nil
        expect(batch).not_to be_valid
      end
    end

  end
end
