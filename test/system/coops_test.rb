require "application_system_test_case"

class CoopsTest < ApplicationSystemTestCase
  setup do
    @coop = coops(:one)
  end

  test "visiting the index" do
    visit coops_url
    assert_selector "h1", text: "Coops"
  end

  test "should create coop" do
    visit coops_url
    click_on "New coop"

    fill_in "Birthdate", with: @coop.birthdate
    fill_in "Coop branch", with: @coop.coop_branch_id
    fill_in "Cooperative", with: @coop.cooperative_id
    fill_in "Designation", with: @coop.designation
    fill_in "First name", with: @coop.first_name
    fill_in "Last name", with: @coop.last_name
    fill_in "Middle name", with: @coop.middle_name
    fill_in "Mobile number", with: @coop.mobile_number
    click_on "Create Coop"

    assert_text "Coop was successfully created"
    click_on "Back"
  end

  test "should update Coop" do
    visit coop_url(@coop)
    click_on "Edit this coop", match: :first

    fill_in "Birthdate", with: @coop.birthdate
    fill_in "Coop branch", with: @coop.coop_branch_id
    fill_in "Cooperative", with: @coop.cooperative_id
    fill_in "Designation", with: @coop.designation
    fill_in "First name", with: @coop.first_name
    fill_in "Last name", with: @coop.last_name
    fill_in "Middle name", with: @coop.middle_name
    fill_in "Mobile number", with: @coop.mobile_number
    click_on "Update Coop"

    assert_text "Coop was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop" do
    visit coop_url(@coop)
    click_on "Destroy this coop", match: :first

    assert_text "Coop was successfully destroyed"
  end
end
