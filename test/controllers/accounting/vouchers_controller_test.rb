require "test_helper"

class Accounting::VouchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accounting_voucher = accounting_vouchers(:one)
  end

  test "should get index" do
    get accounting_vouchers_url
    assert_response :success
  end

  test "should get new" do
    get new_accounting_voucher_url
    assert_response :success
  end

  test "should create accounting_voucher" do
    assert_difference("Accounting::Voucher.count") do
      post accounting_vouchers_url, params: { accounting_voucher: { amount: @accounting_voucher.amount, date_voucher: @accounting_voucher.date_voucher, particulars: @accounting_voucher.particulars, payable_id: @accounting_voucher.payable_id, payable_type: @accounting_voucher.payable_type, treasury_account_id: @accounting_voucher.treasury_account_id, voucher: @accounting_voucher.voucher } }
    end

    assert_redirected_to accounting_voucher_url(Accounting::Voucher.last)
  end

  test "should show accounting_voucher" do
    get accounting_voucher_url(@accounting_voucher)
    assert_response :success
  end

  test "should get edit" do
    get edit_accounting_voucher_url(@accounting_voucher)
    assert_response :success
  end

  test "should update accounting_voucher" do
    patch accounting_voucher_url(@accounting_voucher), params: { accounting_voucher: { amount: @accounting_voucher.amount, date_voucher: @accounting_voucher.date_voucher, particulars: @accounting_voucher.particulars, payable_id: @accounting_voucher.payable_id, payable_type: @accounting_voucher.payable_type, treasury_account_id: @accounting_voucher.treasury_account_id, voucher: @accounting_voucher.voucher } }
    assert_redirected_to accounting_voucher_url(@accounting_voucher)
  end

  test "should destroy accounting_voucher" do
    assert_difference("Accounting::Voucher.count", -1) do
      delete accounting_voucher_url(@accounting_voucher)
    end

    assert_redirected_to accounting_vouchers_url
  end
end
