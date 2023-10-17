require "test_helper"

class Accounting::CheckVouchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accounting_check_voucher = accounting_check_vouchers(:one)
  end

  test "should get index" do
    get accounting_check_vouchers_url
    assert_response :success
  end

  test "should get new" do
    get new_accounting_check_voucher_url
    assert_response :success
  end

  test "should create accounting_check_voucher" do
    assert_difference("Accounting::CheckVoucher.count") do
      post accounting_check_vouchers_url, params: { accounting_check_voucher: { address: @accounting_check_voucher.address, amount: @accounting_check_voucher.amount, date_voucher: @accounting_check_voucher.date_voucher, particulars: @accounting_check_voucher.particulars, payable_id: @accounting_check_voucher.payable_id, payable_type: @accounting_check_voucher.payable_type, voucher: @accounting_check_voucher.voucher } }
    end

    assert_redirected_to accounting_check_voucher_url(Accounting::CheckVoucher.last)
  end

  test "should show accounting_check_voucher" do
    get accounting_check_voucher_url(@accounting_check_voucher)
    assert_response :success
  end

  test "should get edit" do
    get edit_accounting_check_voucher_url(@accounting_check_voucher)
    assert_response :success
  end

  test "should update accounting_check_voucher" do
    patch accounting_check_voucher_url(@accounting_check_voucher), params: { accounting_check_voucher: { address: @accounting_check_voucher.address, amount: @accounting_check_voucher.amount, date_voucher: @accounting_check_voucher.date_voucher, particulars: @accounting_check_voucher.particulars, payable_id: @accounting_check_voucher.payable_id, payable_type: @accounting_check_voucher.payable_type, voucher: @accounting_check_voucher.voucher } }
    assert_redirected_to accounting_check_voucher_url(@accounting_check_voucher)
  end

  test "should destroy accounting_check_voucher" do
    assert_difference("Accounting::CheckVoucher.count", -1) do
      delete accounting_check_voucher_url(@accounting_check_voucher)
    end

    assert_redirected_to accounting_check_vouchers_url
  end
end
