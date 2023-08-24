require "application_system_test_case"

class ClaimTypesTest < ApplicationSystemTestCase
  setup do
    @claim_type = claim_types(:one)
  end

  test "visiting the index" do
    visit claim_types_url
    assert_selector "h1", text: "Claim types"
  end

  test "should create claim type" do
    visit claim_types_url
    click_on "New claim type"

    fill_in "Description", with: @claim_type.description
    fill_in "Name", with: @claim_type.name
    click_on "Create Claim type"

    assert_text "Claim type was successfully created"
    click_on "Back"
  end

  test "should update Claim type" do
    visit claim_type_url(@claim_type)
    click_on "Edit this claim type", match: :first

    fill_in "Description", with: @claim_type.description
    fill_in "Name", with: @claim_type.name
    click_on "Update Claim type"

    assert_text "Claim type was successfully updated"
    click_on "Back"
  end

  test "should destroy Claim type" do
    visit claim_type_url(@claim_type)
    click_on "Destroy this claim type", match: :first

    assert_text "Claim type was successfully destroyed"
  end
end
