require 'rails_helper'

RSpec.describe LoanInsurance::BatchRemit, type: :model do
  let(:batch_remit) { create(:batch_remit) }

  it "will create a new batch remit with valid attributes" do
    expect(batch_remit).to be_valid
  end

  it "is not valid if it's type is not LoanInsurance::BatchRemit" do
    batch_remit.type = 'AnotherType'
    expect(batch_remit).not_to be_valid
  end

  it "is valid if it's type is LoanInsurance::BatchRemit" do
    batch_remit.type = 'LoanInsurance::BatchRemit'
    expect(batch_remit).to be_valid
  end

  it "is not valid without a name" do
    batch_remit.name = nil
    expect(batch_remit).not_to be_valid
  end

  it "is not valid without an effectivity date" do
    batch_remit.effectivity_date = nil
    expect(batch_remit).not_to be_valid
  end

  it "is not valid without an expiry date" do
    batch_remit.expiry_date = nil
    expect(batch_remit).not_to be_valid
  end

  it "is not valid without terms" do
    batch_remit.terms = nil
    expect(batch_remit).not_to be_valid
  end

  it "is not valid without an agreement_id" do
    batch_remit.agreement_id = nil
    expect(batch_remit).not_to be_valid
  end

end
