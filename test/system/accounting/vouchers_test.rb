require "application_system_test_case"

class Accounting::VouchersTest < ApplicationSystemTestCase
  setup do
    @accounting_voucher = accounting_vouchers(:one)
  end

  test "visiting the index" do
    visit accounting_vouchers_url
    assert_selector "h1", text: "Vouchers"
  end

  test "should create voucher" do
    visit accounting_vouchers_url
    click_on "New voucher"

    fill_in "Amount", with: @accounting_voucher.amount
    fill_in "Date voucher", with: @accounting_voucher.date_voucher
    fill_in "Particulars", with: @accounting_voucher.particulars
    fill_in "Payable", with: @accounting_voucher.payable_id
    fill_in "Payable type", with: @accounting_voucher.payable_type
    fill_in "Treasury account", with: @accounting_voucher.treasury_account_id
    fill_in "Voucher", with: @accounting_voucher.voucher
    click_on "Create Voucher"

    assert_text "Voucher was successfully created"
    click_on "Back"
  end

  test "should update Voucher" do
    visit accounting_voucher_url(@accounting_voucher)
    click_on "Edit this voucher", match: :first

    fill_in "Amount", with: @accounting_voucher.amount
    fill_in "Date voucher", with: @accounting_voucher.date_voucher
    fill_in "Particulars", with: @accounting_voucher.particulars
    fill_in "Payable", with: @accounting_voucher.payable_id
    fill_in "Payable type", with: @accounting_voucher.payable_type
    fill_in "Treasury account", with: @accounting_voucher.treasury_account_id
    fill_in "Voucher", with: @accounting_voucher.voucher
    click_on "Update Voucher"

    assert_text "Voucher was successfully updated"
    click_on "Back"
  end

  test "should destroy Voucher" do
    visit accounting_voucher_url(@accounting_voucher)
    click_on "Destroy this voucher", match: :first

    assert_text "Voucher was successfully destroyed"
  end
end
