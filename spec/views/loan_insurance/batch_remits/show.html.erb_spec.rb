require "rails_helper"

RSpec.describe "loan_insurance/batch_remits/show", type: :view do
  before(:each) do
    assign(:loan_insurance_batch_remit, LoanInsurance::BatchRemit.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
