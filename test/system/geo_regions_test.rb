require "application_system_test_case"

class GeoRegionsTest < ApplicationSystemTestCase
  setup do
    @geo_region = geo_regions(:one)
  end

  test "visiting the index" do
    visit geo_regions_url
    assert_selector "h1", text: "Geo regions"
  end

  test "should create geo region" do
    visit geo_regions_url
    click_on "New geo region"

    fill_in "Name", with: @geo_region.name
    click_on "Create Geo region"

    assert_text "Geo region was successfully created"
    click_on "Back"
  end

  test "should update Geo region" do
    visit geo_region_url(@geo_region)
    click_on "Edit this geo region", match: :first

    fill_in "Name", with: @geo_region.name
    click_on "Update Geo region"

    assert_text "Geo region was successfully updated"
    click_on "Back"
  end

  test "should destroy Geo region" do
    visit geo_region_url(@geo_region)
    click_on "Destroy this geo region", match: :first

    assert_text "Geo region was successfully destroyed"
  end
end
