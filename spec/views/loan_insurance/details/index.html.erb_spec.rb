require 'rails_helper'

RSpec.describe "loan_insurance/details/index", type: :view do
  before(:each) do
    assign(:loan_insurance_details, [
      LoanInsurance::Detail.create!(
        batch: nil,
        unuse: "9.99",
        loan_amount: "9.99",
        premium_due: "9.99",
        substandard_rate: "9.99",
        terminate: false,
        reinsurance: false,
        terms: 2
      ),
      LoanInsurance::Detail.create!(
        batch: nil,
        unuse: "9.99",
        loan_amount: "9.99",
        premium_due: "9.99",
        substandard_rate: "9.99",
        terminate: false,
        reinsurance: false,
        terms: 2
      )
    ])
  end

  it "renders a list of loan_insurance/details" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
