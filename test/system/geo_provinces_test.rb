require "application_system_test_case"

class GeoProvincesTest < ApplicationSystemTestCase
  setup do
    @geo_province = geo_provinces(:one)
  end

  test "visiting the index" do
    visit geo_provinces_url
    assert_selector "h1", text: "Geo provinces"
  end

  test "should create geo province" do
    visit geo_provinces_url
    click_on "New geo province"

    fill_in "Geo region", with: @geo_province.geo_region_id
    fill_in "Name", with: @geo_province.name
    click_on "Create Geo province"

    assert_text "Geo province was successfully created"
    click_on "Back"
  end

  test "should update Geo province" do
    visit geo_province_url(@geo_province)
    click_on "Edit this geo province", match: :first

    fill_in "Geo region", with: @geo_province.geo_region_id
    fill_in "Name", with: @geo_province.name
    click_on "Update Geo province"

    assert_text "Geo province was successfully updated"
    click_on "Back"
  end

  test "should destroy Geo province" do
    visit geo_province_url(@geo_province)
    click_on "Destroy this geo province", match: :first

    assert_text "Geo province was successfully destroyed"
  end
end
