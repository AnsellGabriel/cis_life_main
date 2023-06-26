
require "application_system_test_case"

class GeoMunicipalitiesTest < ApplicationSystemTestCase
  setup do
    @geo_municipality = geo_municipalities(:one)
  end

  test "visiting the index" do
    visit geo_municipalities_url
    assert_selector "h1", text: "Geo municipalities"
  end

  test "should create geo municipality" do
    visit geo_municipalities_url
    click_on "New geo municipality"

    fill_in "Geo provice", with: @geo_municipality.geo_provice_id
    fill_in "Geo region", with: @geo_municipality.geo_region_id
    click_on "Create Geo municipality"

    assert_text "Geo municipality was successfully created"
    click_on "Back"
  end

  test "should update Geo municipality" do
    visit geo_municipality_url(@geo_municipality)
    click_on "Edit this geo municipality", match: :first

    fill_in "Geo provice", with: @geo_municipality.geo_provice_id
    fill_in "Geo region", with: @geo_municipality.geo_region_id
    click_on "Update Geo municipality"

    assert_text "Geo municipality was successfully updated"
    click_on "Back"
  end

  test "should destroy Geo municipality" do
    visit geo_municipality_url(@geo_municipality)
    click_on "Destroy this geo municipality", match: :first

    assert_text "Geo municipality was successfully destroyed"
  end
end
