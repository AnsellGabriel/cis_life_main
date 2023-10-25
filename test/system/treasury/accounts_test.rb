require "application_system_test_case"

class Treasury::AccountsTest < ApplicationSystemTestCase
  setup do
    @treasury_account = treasury_accounts(:one)
  end

  test "visiting the index" do
    visit treasury_accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "should create account" do
    visit treasury_accounts_url
    click_on "New account"

    fill_in "Account type", with: @treasury_account.account_type
    fill_in "Address", with: @treasury_account.address
    fill_in "Contact number", with: @treasury_account.contact_number
    check "Is check account" if @treasury_account.is_check_account
    fill_in "Name", with: @treasury_account.name
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "should update Account" do
    visit treasury_account_url(@treasury_account)
    click_on "Edit this account", match: :first

    fill_in "Account type", with: @treasury_account.account_type
    fill_in "Address", with: @treasury_account.address
    fill_in "Contact number", with: @treasury_account.contact_number
    check "Is check account" if @treasury_account.is_check_account
    fill_in "Name", with: @treasury_account.name
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "should destroy Account" do
    visit treasury_account_url(@treasury_account)
    click_on "Destroy this account", match: :first

    assert_text "Account was successfully destroyed"
  end
end
