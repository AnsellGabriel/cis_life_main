require "application_system_test_case"

class ProcessRoutesTest < ApplicationSystemTestCase
  setup do
    @process_route = process_routes(:one)
  end

  test "visiting the index" do
    visit process_routes_url
    assert_selector "h1", text: "Process routes"
  end

  test "should create process route" do
    visit process_routes_url
    click_on "New process route"

    fill_in "Department", with: @process_route.department
    fill_in "Description", with: @process_route.description
    fill_in "Name", with: @process_route.name
    click_on "Create Process route"

    assert_text "Process route was successfully created"
    click_on "Back"
  end

  test "should update Process route" do
    visit process_route_url(@process_route)
    click_on "Edit this process route", match: :first

    fill_in "Department", with: @process_route.department
    fill_in "Description", with: @process_route.description
    fill_in "Name", with: @process_route.name
    click_on "Update Process route"

    assert_text "Process route was successfully updated"
    click_on "Back"
  end

  test "should destroy Process route" do
    visit process_route_url(@process_route)
    click_on "Destroy this process route", match: :first

    assert_text "Process route was successfully destroyed"
  end
end
