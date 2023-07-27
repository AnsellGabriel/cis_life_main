require "application_system_test_case"

class AuthorityLevelsTest < ApplicationSystemTestCase
  setup do
    @authority_level = authority_levels(:one)
  end

  test "visiting the index" do
    visit authority_levels_url
    assert_selector "h1", text: "Authority levels"
  end

  test "should create authority level" do
    visit authority_levels_url
    click_on "New authority level"

    fill_in "Maxamount", with: @authority_level.maxAmount
    fill_in "Name", with: @authority_level.name
    click_on "Create Authority level"

    assert_text "Authority level was successfully created"
    click_on "Back"
  end

  test "should update Authority level" do
    visit authority_level_url(@authority_level)
    click_on "Edit this authority level", match: :first

    fill_in "Maxamount", with: @authority_level.maxAmount
    fill_in "Name", with: @authority_level.name
    click_on "Update Authority level"

    assert_text "Authority level was successfully updated"
    click_on "Back"
  end

  test "should destroy Authority level" do
    visit authority_level_url(@authority_level)
    click_on "Destroy this authority level", match: :first

    assert_text "Authority level was successfully destroyed"
  end
end
