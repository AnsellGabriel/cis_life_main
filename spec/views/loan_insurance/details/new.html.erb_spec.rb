require 'rails_helper'

RSpec.describe "loan_insurance/details/new", type: :view do
  before(:each) do
    assign(:loan_insurance_detail, LoanInsurance::Detail.new(
      batch: nil,
      unuse: "9.99",
      loan_amount: "9.99",
      premium_due: "9.99",
      substandard_rate: "9.99",
      terminate: false,
      reinsurance: false,
      terms: 1
    ))
  end

  it "renders new loan_insurance_detail form" do
    render

    assert_select "form[action=?][method=?]", loan_insurance_details_path, "post" do

      assert_select "input[name=?]", "loan_insurance_detail[batch_id]"

      assert_select "input[name=?]", "loan_insurance_detail[unuse]"

      assert_select "input[name=?]", "loan_insurance_detail[loan_amount]"

      assert_select "input[name=?]", "loan_insurance_detail[premium_due]"

      assert_select "input[name=?]", "loan_insurance_detail[substandard_rate]"

      assert_select "input[name=?]", "loan_insurance_detail[terminate]"

      assert_select "input[name=?]", "loan_insurance_detail[reinsurance]"

      assert_select "input[name=?]", "loan_insurance_detail[terms]"
    end
  end
end
