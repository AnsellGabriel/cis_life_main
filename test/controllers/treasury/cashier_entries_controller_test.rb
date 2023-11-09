require "test_helper"

class Treasury::CashierEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @treasury_cashier_entry = treasury_cashier_entries(:one)
  end

  test "should get index" do
    get treasury_cashier_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_treasury_cashier_entry_url
    assert_response :success
  end

  test "should create treasury_cashier_entry" do
    assert_difference("Treasury::CashierEntry.count") do
      post treasury_cashier_entries_url, params: { treasury_cashier_entry: { amount: @treasury_cashier_entry.amount, entriable_id: @treasury_cashier_entry.entriable_id, entriable_type: @treasury_cashier_entry.entriable_type, or_date: @treasury_cashier_entry.or_date, or_no: @treasury_cashier_entry.or_no, payment: @treasury_cashier_entry.payment, treasury_account_id: @treasury_cashier_entry.treasury_account_id } }
    end

    assert_redirected_to treasury_cashier_entry_url(Treasury::CashierEntry.last)
  end

  test "should show treasury_cashier_entry" do
    get treasury_cashier_entry_url(@treasury_cashier_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_treasury_cashier_entry_url(@treasury_cashier_entry)
    assert_response :success
  end

  test "should update treasury_cashier_entry" do
    patch treasury_cashier_entry_url(@treasury_cashier_entry), params: { treasury_cashier_entry: { amount: @treasury_cashier_entry.amount, entriable_id: @treasury_cashier_entry.entriable_id, entriable_type: @treasury_cashier_entry.entriable_type, or_date: @treasury_cashier_entry.or_date, or_no: @treasury_cashier_entry.or_no, payment: @treasury_cashier_entry.payment, treasury_account_id: @treasury_cashier_entry.treasury_account_id } }
    assert_redirected_to treasury_cashier_entry_url(@treasury_cashier_entry)
  end

  test "should destroy treasury_cashier_entry" do
    assert_difference("Treasury::CashierEntry.count", -1) do
      delete treasury_cashier_entry_url(@treasury_cashier_entry)
    end

    assert_redirected_to treasury_cashier_entries_url
  end
end
