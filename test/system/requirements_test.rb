require "application_system_test_case"

class RequirementsTest < ApplicationSystemTestCase
  setup do
    @requirement = requirements(:one)
  end

  test "visiting the index" do
    visit requirements_url
    assert_selector "h1", text: "Requirements"
  end

  test "should create requirement" do
    visit requirements_url
    click_on "New requirement"

    fill_in "Description", with: @requirement.description
    fill_in "Name", with: @requirement.name
    click_on "Create Requirement"

    assert_text "Requirement was successfully created"
    click_on "Back"
  end

  test "should update Requirement" do
    visit requirement_url(@requirement)
    click_on "Edit this requirement", match: :first

    fill_in "Description", with: @requirement.description
    fill_in "Name", with: @requirement.name
    click_on "Update Requirement"

    assert_text "Requirement was successfully updated"
    click_on "Back"
  end

  test "should destroy Requirement" do
    visit requirement_url(@requirement)
    click_on "Destroy this requirement", match: :first

    assert_text "Requirement was successfully destroyed"
  end
end
