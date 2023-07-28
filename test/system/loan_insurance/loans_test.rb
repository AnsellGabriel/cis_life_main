require "application_system_test_case"

class LoanInsurance::LoansTest < ApplicationSystemTestCase
  setup do
    @loan_insurance_loan = loan_insurance_loans(:one)
  end

  test "visiting the index" do
    visit loan_insurance_loans_url
    assert_selector "h1", text: "Loans"
  end

  test "should create loan" do
    visit loan_insurance_loans_url
    click_on "New loan"

    fill_in "Cooperative", with: @loan_insurance_loan.cooperative_id
    fill_in "Description", with: @loan_insurance_loan.description
    fill_in "Name", with: @loan_insurance_loan.name
    click_on "Create Loan"

    assert_text "Loan was successfully created"
    click_on "Back"
  end

  test "should update Loan" do
    visit loan_insurance_loan_url(@loan_insurance_loan)
    click_on "Edit this loan", match: :first

    fill_in "Cooperative", with: @loan_insurance_loan.cooperative_id
    fill_in "Description", with: @loan_insurance_loan.description
    fill_in "Name", with: @loan_insurance_loan.name
    click_on "Update Loan"

    assert_text "Loan was successfully updated"
    click_on "Back"
  end

  test "should destroy Loan" do
    visit loan_insurance_loan_url(@loan_insurance_loan)
    click_on "Destroy this loan", match: :first

    assert_text "Loan was successfully destroyed"
  end
end
