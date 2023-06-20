require "test_helper"

class GeoProvincesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_province = geo_provinces(:one)
  end

  test "should get index" do
    get geo_provinces_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_province_url
    assert_response :success
  end

  test "should create geo_province" do
    assert_difference("GeoProvince.count") do
      post geo_provinces_url, params: { geo_province: { geo_region_id: @geo_province.geo_region_id, name: @geo_province.name } }
    end

    assert_redirected_to geo_province_url(GeoProvince.last)
  end

  test "should show geo_province" do
    get geo_province_url(@geo_province)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_province_url(@geo_province)
    assert_response :success
  end

  test "should update geo_province" do
    patch geo_province_url(@geo_province), params: { geo_province: { geo_region_id: @geo_province.geo_region_id, name: @geo_province.name } }
    assert_redirected_to geo_province_url(@geo_province)
  end

  test "should destroy geo_province" do
    assert_difference("GeoProvince.count", -1) do
      delete geo_province_url(@geo_province)
    end

    assert_redirected_to geo_provinces_url
  end
end
