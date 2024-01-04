require "test_helper"

class LoanInsurance::RatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan_insurance_rate = loan_insurance_rates(:one)
  end

  test "should get index" do
    get loan_insurance_rates_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_insurance_rate_url
    assert_response :success
  end

  test "should create loan_insurance_rate" do
    assert_difference("LoanInsurance::Rate.count") do
      post loan_insurance_rates_url,
params: { loan_insurance_rate: { annual_rate: @loan_insurance_rate.annual_rate, daily_rate: @loan_insurance_rate.daily_rate, max_age: @loan_insurance_rate.max_age,
min_age: @loan_insurance_rate.min_age, monthly_rate: @loan_insurance_rate.monthly_rate } }
    end

    assert_redirected_to loan_insurance_rate_url(LoanInsurance::Rate.last)
  end

  test "should show loan_insurance_rate" do
    get loan_insurance_rate_url(@loan_insurance_rate)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_insurance_rate_url(@loan_insurance_rate)
    assert_response :success
  end

  test "should update loan_insurance_rate" do
    patch loan_insurance_rate_url(@loan_insurance_rate),
params: { loan_insurance_rate: { annual_rate: @loan_insurance_rate.annual_rate, daily_rate: @loan_insurance_rate.daily_rate, max_age: @loan_insurance_rate.max_age,
min_age: @loan_insurance_rate.min_age, monthly_rate: @loan_insurance_rate.monthly_rate } }
    assert_redirected_to loan_insurance_rate_url(@loan_insurance_rate)
  end

  test "should destroy loan_insurance_rate" do
    assert_difference("LoanInsurance::Rate.count", -1) do
      delete loan_insurance_rate_url(@loan_insurance_rate)
    end

    assert_redirected_to loan_insurance_rates_url
  end
end
