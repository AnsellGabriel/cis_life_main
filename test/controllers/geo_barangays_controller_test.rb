require "test_helper"

class GeoBarangaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_barangay = geo_barangays(:one)
  end

  test "should get index" do
    get geo_barangays_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_barangay_url
    assert_response :success
  end

  test "should create geo_barangay" do
    assert_difference("GeoBarangay.count") do
      post geo_barangays_url, params: { geo_barangay: { geo_municipality_id: @geo_barangay.geo_municipality_id, geo_province_id: @geo_barangay.geo_province_id, geo_region_id: @geo_barangay.geo_region_id, psgc_code: @geo_barangay.psgc_code } }
    end

    assert_redirected_to geo_barangay_url(GeoBarangay.last)
  end

  test "should show geo_barangay" do
    get geo_barangay_url(@geo_barangay)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_barangay_url(@geo_barangay)
    assert_response :success
  end

  test "should update geo_barangay" do
    patch geo_barangay_url(@geo_barangay), params: { geo_barangay: { geo_municipality_id: @geo_barangay.geo_municipality_id, geo_province_id: @geo_barangay.geo_province_id, geo_region_id: @geo_barangay.geo_region_id, psgc_code: @geo_barangay.psgc_code } }
    assert_redirected_to geo_barangay_url(@geo_barangay)
  end

  test "should destroy geo_barangay" do
    assert_difference("GeoBarangay.count", -1) do
      delete geo_barangay_url(@geo_barangay)
    end

    assert_redirected_to geo_barangays_url
  end
end
