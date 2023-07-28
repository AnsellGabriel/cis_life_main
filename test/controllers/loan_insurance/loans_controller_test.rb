require "test_helper"

class LoanInsurance::LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan_insurance_loan = loan_insurance_loans(:one)
  end

  test "should get index" do
    get loan_insurance_loans_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_insurance_loan_url
    assert_response :success
  end

  test "should create loan_insurance_loan" do
    assert_difference("LoanInsurance::Loan.count") do
      post loan_insurance_loans_url, params: { loan_insurance_loan: { cooperative_id: @loan_insurance_loan.cooperative_id, description: @loan_insurance_loan.description, name: @loan_insurance_loan.name } }
    end

    assert_redirected_to loan_insurance_loan_url(LoanInsurance::Loan.last)
  end

  test "should show loan_insurance_loan" do
    get loan_insurance_loan_url(@loan_insurance_loan)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_insurance_loan_url(@loan_insurance_loan)
    assert_response :success
  end

  test "should update loan_insurance_loan" do
    patch loan_insurance_loan_url(@loan_insurance_loan), params: { loan_insurance_loan: { cooperative_id: @loan_insurance_loan.cooperative_id, description: @loan_insurance_loan.description, name: @loan_insurance_loan.name } }
    assert_redirected_to loan_insurance_loan_url(@loan_insurance_loan)
  end

  test "should destroy loan_insurance_loan" do
    assert_difference("LoanInsurance::Loan.count", -1) do
      delete loan_insurance_loan_url(@loan_insurance_loan)
    end

    assert_redirected_to loan_insurance_loans_url
  end
end
