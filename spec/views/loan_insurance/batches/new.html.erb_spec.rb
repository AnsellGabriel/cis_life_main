require 'rails_helper'

RSpec.describe "loan_insurance/batches/new", type: :view do
  before(:each) do
    assign(:loan_insurance_batch, LoanInsurance::Batch.new())
  end

  it "renders new loan_insurance_batch form" do
    render

    assert_select "form[action=?][method=?]", loan_insurance_batches_path, "post" do
    end
  end
end
