require "rails_helper"

RSpec.describe "loan_insurance/batch_remits/edit", type: :view do
  let(:loan_insurance_batch_remit) {
    LoanInsurance::BatchRemit.create!()
  }

  before(:each) do
    assign(:loan_insurance_batch_remit, loan_insurance_batch_remit)
  end

  it "renders the edit loan_insurance_batch_remit form" do
    render

    assert_select "form[action=?][method=?]", loan_insurance_batch_remit_path(loan_insurance_batch_remit), "post" do
    end
  end
end
