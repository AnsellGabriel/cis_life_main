require "application_system_test_case"

class CoopTypesTest < ApplicationSystemTestCase
  setup do
    @coop_type = coop_types(:one)
  end

  test "visiting the index" do
    visit coop_types_url
    assert_selector "h1", text: "Coop types"
  end

  test "should create coop type" do
    visit coop_types_url
    click_on "New coop type"

    fill_in "Description", with: @coop_type.description
    fill_in "Name", with: @coop_type.name
    click_on "Create Coop type"

    assert_text "Coop type was successfully created"
    click_on "Back"
  end

  test "should update Coop type" do
    visit coop_type_url(@coop_type)
    click_on "Edit this coop type", match: :first

    fill_in "Description", with: @coop_type.description
    fill_in "Name", with: @coop_type.name
    click_on "Update Coop type"

    assert_text "Coop type was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop type" do
    visit coop_type_url(@coop_type)
    click_on "Destroy this coop type", match: :first

    assert_text "Coop type was successfully destroyed"
  end
end
