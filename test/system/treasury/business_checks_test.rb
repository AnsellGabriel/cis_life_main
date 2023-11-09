require "application_system_test_case"

class Treasury::BusinessChecksTest < ApplicationSystemTestCase
  setup do
    @treasury_business_check = treasury_business_checks(:one)
  end

  test "visiting the index" do
    visit treasury_business_checks_url
    assert_selector "h1", text: "Business checks"
  end

  test "should create business check" do
    visit treasury_business_checks_url
    click_on "New business check"

    fill_in "Amount", with: @treasury_business_check.amount
    fill_in "Check date", with: @treasury_business_check.check_date
    fill_in "Check number", with: @treasury_business_check.check_number
    fill_in "Check type", with: @treasury_business_check.check_type
    click_on "Create Business check"

    assert_text "Business check was successfully created"
    click_on "Back"
  end

  test "should update Business check" do
    visit treasury_business_check_url(@treasury_business_check)
    click_on "Edit this business check", match: :first

    fill_in "Amount", with: @treasury_business_check.amount
    fill_in "Check date", with: @treasury_business_check.check_date
    fill_in "Check number", with: @treasury_business_check.check_number
    fill_in "Check type", with: @treasury_business_check.check_type
    click_on "Update Business check"

    assert_text "Business check was successfully updated"
    click_on "Back"
  end

  test "should destroy Business check" do
    visit treasury_business_check_url(@treasury_business_check)
    click_on "Destroy this business check", match: :first

    assert_text "Business check was successfully destroyed"
  end
end
