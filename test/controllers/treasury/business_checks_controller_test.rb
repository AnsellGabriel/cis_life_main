require "test_helper"

class Treasury::BusinessChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @treasury_business_check = treasury_business_checks(:one)
  end

  test "should get index" do
    get treasury_business_checks_url
    assert_response :success
  end

  test "should get new" do
    get new_treasury_business_check_url
    assert_response :success
  end

  test "should create treasury_business_check" do
    assert_difference("Treasury::BusinessCheck.count") do
      post treasury_business_checks_url, params: { treasury_business_check: { amount: @treasury_business_check.amount, check_date: @treasury_business_check.check_date, check_number: @treasury_business_check.check_number, check_type: @treasury_business_check.check_type } }
    end

    assert_redirected_to treasury_business_check_url(Treasury::BusinessCheck.last)
  end

  test "should show treasury_business_check" do
    get treasury_business_check_url(@treasury_business_check)
    assert_response :success
  end

  test "should get edit" do
    get edit_treasury_business_check_url(@treasury_business_check)
    assert_response :success
  end

  test "should update treasury_business_check" do
    patch treasury_business_check_url(@treasury_business_check), params: { treasury_business_check: { amount: @treasury_business_check.amount, check_date: @treasury_business_check.check_date, check_number: @treasury_business_check.check_number, check_type: @treasury_business_check.check_type } }
    assert_redirected_to treasury_business_check_url(@treasury_business_check)
  end

  test "should destroy treasury_business_check" do
    assert_difference("Treasury::BusinessCheck.count", -1) do
      delete treasury_business_check_url(@treasury_business_check)
    end

    assert_redirected_to treasury_business_checks_url
  end
end
