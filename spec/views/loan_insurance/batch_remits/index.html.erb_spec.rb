require "rails_helper"

RSpec.describe "loan_insurance/batch_remits/index", type: :view do
  before(:each) do
    assign(:loan_insurance_batch_remits, [
      LoanInsurance::BatchRemit.create!(),
      LoanInsurance::BatchRemit.create!()
    ])
  end

  it "renders a list of loan_insurance/batch_remits" do
    render
    cell_selector = Rails::VERSION::STRING >= "7" ? "div>p" : "tr>td"
  end
end
