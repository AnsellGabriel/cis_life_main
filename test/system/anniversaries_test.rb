require "application_system_test_case"

class AnniversariesTest < ApplicationSystemTestCase
  setup do
    @anniversary = anniversaries(:one)
  end

  test "visiting the index" do
    visit anniversaries_url
    assert_selector "h1", text: "Anniversaries"
  end

  test "should create anniversary" do
    visit anniversaries_url
    click_on "New anniversary"

    fill_in "Anniversary date", with: @anniversary.anniversary_date
    fill_in "Name", with: @anniversary.name
    click_on "Create Anniversary"

    assert_text "Anniversary was successfully created"
    click_on "Back"
  end

  test "should update Anniversary" do
    visit anniversary_url(@anniversary)
    click_on "Edit this anniversary", match: :first

    fill_in "Anniversary date", with: @anniversary.anniversary_date
    fill_in "Name", with: @anniversary.name
    click_on "Update Anniversary"

    assert_text "Anniversary was successfully updated"
    click_on "Back"
  end

  test "should destroy Anniversary" do
    visit anniversary_url(@anniversary)
    click_on "Destroy this anniversary", match: :first

    assert_text "Anniversary was successfully destroyed"
  end
end
