require 'rails_helper'

RSpec.describe "loan_insurance/batch_remits/new", type: :view do
  before(:each) do
    assign(:loan_insurance_batch_remit, LoanInsurance::BatchRemit.new())
  end

  it "renders new loan_insurance_batch_remit form" do
    render

    assert_select "form[action=?][method=?]", loan_insurance_batch_remits_path, "post" do
    end
  end
end
