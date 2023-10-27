require "application_system_test_case"

class Accounting::ChecksTest < ApplicationSystemTestCase
  setup do
    @accounting_check = accounting_checks(:one)
  end

  test "visiting the index" do
    visit accounting_checks_url
    assert_selector "h1", text: "Checks"
  end

  test "should create check" do
    visit accounting_checks_url
    click_on "New check"

    click_on "Create Check"

    assert_text "Check was successfully created"
    click_on "Back"
  end

  test "should update Check" do
    visit accounting_check_url(@accounting_check)
    click_on "Edit this check", match: :first

    click_on "Update Check"

    assert_text "Check was successfully updated"
    click_on "Back"
  end

  test "should destroy Check" do
    visit accounting_check_url(@accounting_check)
    click_on "Destroy this check", match: :first

    assert_text "Check was successfully destroyed"
  end
end
