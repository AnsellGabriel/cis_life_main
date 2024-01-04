require "rails_helper"

RSpec.describe "loan_insurance/batches/show", type: :view do
  before(:each) do
    assign(:loan_insurance_batch, LoanInsurance::Batch.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
