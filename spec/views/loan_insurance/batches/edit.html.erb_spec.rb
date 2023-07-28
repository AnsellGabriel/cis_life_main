require 'rails_helper'

RSpec.describe "loan_insurance/batches/edit", type: :view do
  let(:loan_insurance_batch) {
    LoanInsurance::Batch.create!()
  }

  before(:each) do
    assign(:loan_insurance_batch, loan_insurance_batch)
  end

  it "renders the edit loan_insurance_batch form" do
    render

    assert_select "form[action=?][method=?]", loan_insurance_batch_path(loan_insurance_batch), "post" do
    end
  end
end
