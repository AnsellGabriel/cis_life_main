require "rails_helper"

RSpec.describe "loan_insurance/details/show", type: :view do
  before(:each) do
    assign(:loan_insurance_detail, LoanInsurance::Detail.create!(
      batch: nil,
      unuse: "9.99",
      loan_amount: "9.99",
      premium_due: "9.99",
      substandard_rate: "9.99",
      terminate: false,
      reinsurance: false,
      terms: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
  end
end
