require "rails_helper"

RSpec.describe "loan_insurance/batches/index", type: :view do
  before(:each) do
    assign(:loan_insurance_batches, [
      LoanInsurance::Batch.create!(),
      LoanInsurance::Batch.create!()
    ])
  end

  it "renders a list of loan_insurance/batches" do
    render
    cell_selector = Rails::VERSION::STRING >= "7" ? "div>p" : "tr>td"
  end
end
