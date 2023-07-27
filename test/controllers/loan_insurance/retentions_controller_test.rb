require "test_helper"

class LoanInsurance::RetentionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan_insurance_retention = loan_insurance_retentions(:one)
  end

  test "should get index" do
    get loan_insurance_retentions_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_insurance_retention_url
    assert_response :success
  end

  test "should create loan_insurance_retention" do
    assert_difference("LoanInsurance::Retention.count") do
      post loan_insurance_retentions_url, params: { loan_insurance_retention: { active: @loan_insurance_retention.active, amount: @loan_insurance_retention.amount, date_activated: @loan_insurance_retention.date_activated, date_deactivated: @loan_insurance_retention.date_deactivated } }
    end

    assert_redirected_to loan_insurance_retention_url(LoanInsurance::Retention.last)
  end

  test "should show loan_insurance_retention" do
    get loan_insurance_retention_url(@loan_insurance_retention)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_insurance_retention_url(@loan_insurance_retention)
    assert_response :success
  end

  test "should update loan_insurance_retention" do
    patch loan_insurance_retention_url(@loan_insurance_retention), params: { loan_insurance_retention: { active: @loan_insurance_retention.active, amount: @loan_insurance_retention.amount, date_activated: @loan_insurance_retention.date_activated, date_deactivated: @loan_insurance_retention.date_deactivated } }
    assert_redirected_to loan_insurance_retention_url(@loan_insurance_retention)
  end

  test "should destroy loan_insurance_retention" do
    assert_difference("LoanInsurance::Retention.count", -1) do
      delete loan_insurance_retention_url(@loan_insurance_retention)
    end

    assert_redirected_to loan_insurance_retentions_url
  end
end
