require "test_helper"

class Accounting::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accounting_check = accounting_checks(:one)
  end

  test "should get index" do
    get accounting_checks_url
    assert_response :success
  end

  test "should get new" do
    get new_accounting_check_url
    assert_response :success
  end

  test "should create accounting_check" do
    assert_difference("Accounting::Check.count") do
      post accounting_checks_url, params: { accounting_check: {  } }
    end

    assert_redirected_to accounting_check_url(Accounting::Check.last)
  end

  test "should show accounting_check" do
    get accounting_check_url(@accounting_check)
    assert_response :success
  end

  test "should get edit" do
    get edit_accounting_check_url(@accounting_check)
    assert_response :success
  end

  test "should update accounting_check" do
    patch accounting_check_url(@accounting_check), params: { accounting_check: {  } }
    assert_redirected_to accounting_check_url(@accounting_check)
  end

  test "should destroy accounting_check" do
    assert_difference("Accounting::Check.count", -1) do
      delete accounting_check_url(@accounting_check)
    end

    assert_redirected_to accounting_checks_url
  end
end
