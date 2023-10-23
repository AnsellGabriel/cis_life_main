require "test_helper"

class Treasury::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @treasury_account = treasury_accounts(:one)
  end

  test "should get index" do
    get treasury_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_treasury_account_url
    assert_response :success
  end

  test "should create treasury_account" do
    assert_difference("Treasury::Account.count") do
      post treasury_accounts_url, params: { treasury_account: { account_type: @treasury_account.account_type, address: @treasury_account.address, contact_number: @treasury_account.contact_number, is_check_account: @treasury_account.is_check_account, name: @treasury_account.name } }
    end

    assert_redirected_to treasury_account_url(Treasury::Account.last)
  end

  test "should show treasury_account" do
    get treasury_account_url(@treasury_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_treasury_account_url(@treasury_account)
    assert_response :success
  end

  test "should update treasury_account" do
    patch treasury_account_url(@treasury_account), params: { treasury_account: { account_type: @treasury_account.account_type, address: @treasury_account.address, contact_number: @treasury_account.contact_number, is_check_account: @treasury_account.is_check_account, name: @treasury_account.name } }
    assert_redirected_to treasury_account_url(@treasury_account)
  end

  test "should destroy treasury_account" do
    assert_difference("Treasury::Account.count", -1) do
      delete treasury_account_url(@treasury_account)
    end

    assert_redirected_to treasury_accounts_url
  end
end
