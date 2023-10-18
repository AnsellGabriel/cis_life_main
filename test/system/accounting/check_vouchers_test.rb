require "application_system_test_case"

class Accounting::CheckVouchersTest < ApplicationSystemTestCase
  setup do
    @accounting_check_voucher = accounting_check_vouchers(:one)
  end

  test "visiting the index" do
    visit accounting_check_vouchers_url
    assert_selector "h1", text: "Check vouchers"
  end

  test "should create check voucher" do
    visit accounting_check_vouchers_url
    click_on "New check voucher"

    fill_in "Address", with: @accounting_check_voucher.address
    fill_in "Amount", with: @accounting_check_voucher.amount
    fill_in "Date voucher", with: @accounting_check_voucher.date_voucher
    fill_in "Particulars", with: @accounting_check_voucher.particulars
    fill_in "Payable", with: @accounting_check_voucher.payable_id
    fill_in "Payable type", with: @accounting_check_voucher.payable_type
    fill_in "Voucher", with: @accounting_check_voucher.voucher
    click_on "Create Check voucher"

    assert_text "Check voucher was successfully created"
    click_on "Back"
  end

  test "should update Check voucher" do
    visit accounting_check_voucher_url(@accounting_check_voucher)
    click_on "Edit this check voucher", match: :first

    fill_in "Address", with: @accounting_check_voucher.address
    fill_in "Amount", with: @accounting_check_voucher.amount
    fill_in "Date voucher", with: @accounting_check_voucher.date_voucher
    fill_in "Particulars", with: @accounting_check_voucher.particulars
    fill_in "Payable", with: @accounting_check_voucher.payable_id
    fill_in "Payable type", with: @accounting_check_voucher.payable_type
    fill_in "Voucher", with: @accounting_check_voucher.voucher
    click_on "Update Check voucher"

    assert_text "Check voucher was successfully updated"
    click_on "Back"
  end

  test "should destroy Check voucher" do
    visit accounting_check_voucher_url(@accounting_check_voucher)
    click_on "Destroy this check voucher", match: :first

    assert_text "Check voucher was successfully destroyed"
  end
end
