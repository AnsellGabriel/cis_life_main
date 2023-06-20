require "application_system_test_case"

class GeoBarangaysTest < ApplicationSystemTestCase
  setup do
    @geo_barangay = geo_barangays(:one)
  end

  test "visiting the index" do
    visit geo_barangays_url
    assert_selector "h1", text: "Geo barangays"
  end

  test "should create geo barangay" do
    visit geo_barangays_url
    click_on "New geo barangay"

    fill_in "Geo municipality", with: @geo_barangay.geo_municipality_id
    fill_in "Geo province", with: @geo_barangay.geo_province_id
    fill_in "Geo region", with: @geo_barangay.geo_region_id
    fill_in "Psgc code", with: @geo_barangay.psgc_code
    click_on "Create Geo barangay"

    assert_text "Geo barangay was successfully created"
    click_on "Back"
  end

  test "should update Geo barangay" do
    visit geo_barangay_url(@geo_barangay)
    click_on "Edit this geo barangay", match: :first

    fill_in "Geo municipality", with: @geo_barangay.geo_municipality_id
    fill_in "Geo province", with: @geo_barangay.geo_province_id
    fill_in "Geo region", with: @geo_barangay.geo_region_id
    fill_in "Psgc code", with: @geo_barangay.psgc_code
    click_on "Update Geo barangay"

    assert_text "Geo barangay was successfully updated"
    click_on "Back"
  end

  test "should destroy Geo barangay" do
    visit geo_barangay_url(@geo_barangay)
    click_on "Destroy this geo barangay", match: :first

    assert_text "Geo barangay was successfully destroyed"
  end
end
