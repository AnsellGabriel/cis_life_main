require "test_helper"

class GeoRegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_region = geo_regions(:one)
  end

  test "should get index" do
    get geo_regions_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_region_url
    assert_response :success
  end

  test "should create geo_region" do
    assert_difference("GeoRegion.count") do
      post geo_regions_url, params: { geo_region: { name: @geo_region.name } }
    end

    assert_redirected_to geo_region_url(GeoRegion.last)
  end

  test "should show geo_region" do
    get geo_region_url(@geo_region)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_region_url(@geo_region)
    assert_response :success
  end

  test "should update geo_region" do
    patch geo_region_url(@geo_region), params: { geo_region: { name: @geo_region.name } }
    assert_redirected_to geo_region_url(@geo_region)
  end

  test "should destroy geo_region" do
    assert_difference("GeoRegion.count", -1) do
      delete geo_region_url(@geo_region)
    end

    assert_redirected_to geo_regions_url
  end
end
