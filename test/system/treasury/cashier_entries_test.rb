require "application_system_test_case"

class Treasury::CashierEntriesTest < ApplicationSystemTestCase
  setup do
    @treasury_cashier_entry = treasury_cashier_entries(:one)
  end

  test "visiting the index" do
    visit treasury_cashier_entries_url
    assert_selector "h1", text: "Cashier entries"
  end

  test "should create cashier entry" do
    visit treasury_cashier_entries_url
    click_on "New cashier entry"

    fill_in "Amount", with: @treasury_cashier_entry.amount
    fill_in "Entriable", with: @treasury_cashier_entry.entriable_id
    fill_in "Entriable type", with: @treasury_cashier_entry.entriable_type
    fill_in "Or date", with: @treasury_cashier_entry.or_date
    fill_in "Or no", with: @treasury_cashier_entry.or_no
    fill_in "Payment", with: @treasury_cashier_entry.payment
    fill_in "Treasury account", with: @treasury_cashier_entry.treasury_account_id
    click_on "Create Cashier entry"

    assert_text "Cashier entry was successfully created"
    click_on "Back"
  end

  test "should update Cashier entry" do
    visit treasury_cashier_entry_url(@treasury_cashier_entry)
    click_on "Edit this cashier entry", match: :first

    fill_in "Amount", with: @treasury_cashier_entry.amount
    fill_in "Entriable", with: @treasury_cashier_entry.entriable_id
    fill_in "Entriable type", with: @treasury_cashier_entry.entriable_type
    fill_in "Or date", with: @treasury_cashier_entry.or_date
    fill_in "Or no", with: @treasury_cashier_entry.or_no
    fill_in "Payment", with: @treasury_cashier_entry.payment
    fill_in "Treasury account", with: @treasury_cashier_entry.treasury_account_id
    click_on "Update Cashier entry"

    assert_text "Cashier entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Cashier entry" do
    visit treasury_cashier_entry_url(@treasury_cashier_entry)
    click_on "Destroy this cashier entry", match: :first

    assert_text "Cashier entry was successfully destroyed"
  end
end
