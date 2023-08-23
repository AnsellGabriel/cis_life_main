require "application_system_test_case"

class CausesTest < ApplicationSystemTestCase
  setup do
    @cause = causes(:one)
  end

  test "visiting the index" do
    visit causes_url
    assert_selector "h1", text: "Causes"
  end

  test "should create cause" do
    visit causes_url
    click_on "New cause"

    fill_in "Description", with: @cause.description
    fill_in "Name", with: @cause.name
    click_on "Create Cause"

    assert_text "Cause was successfully created"
    click_on "Back"
  end

  test "should update Cause" do
    visit cause_url(@cause)
    click_on "Edit this cause", match: :first

    fill_in "Description", with: @cause.description
    fill_in "Name", with: @cause.name
    click_on "Update Cause"

    assert_text "Cause was successfully updated"
    click_on "Back"
  end

  test "should destroy Cause" do
    visit cause_url(@cause)
    click_on "Destroy this cause", match: :first

    assert_text "Cause was successfully destroyed"
  end
end
