require "application_system_test_case"

class UnderwritingRoutesTest < ApplicationSystemTestCase
  setup do
    @underwriting_route = underwriting_routes(:one)
  end

  test "visiting the index" do
    visit underwriting_routes_url
    assert_selector "h1", text: "Underwriting routes"
  end

  test "should create underwriting route" do
    visit underwriting_routes_url
    click_on "New underwriting route"

    fill_in "Description", with: @underwriting_route.description
    fill_in "Name", with: @underwriting_route.name
    click_on "Create Underwriting route"

    assert_text "Underwriting route was successfully created"
    click_on "Back"
  end

  test "should update Underwriting route" do
    visit underwriting_route_url(@underwriting_route)
    click_on "Edit this underwriting route", match: :first

    fill_in "Description", with: @underwriting_route.description
    fill_in "Name", with: @underwriting_route.name
    click_on "Update Underwriting route"

    assert_text "Underwriting route was successfully updated"
    click_on "Back"
  end

  test "should destroy Underwriting route" do
    visit underwriting_route_url(@underwriting_route)
    click_on "Destroy this underwriting route", match: :first

    assert_text "Underwriting route was successfully destroyed"
  end
end
