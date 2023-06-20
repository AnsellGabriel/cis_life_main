require "test_helper"

class GeoMunicipalitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_municipality = geo_municipalities(:one)
  end

  test "should get index" do
    get geo_municipalities_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_municipality_url
    assert_response :success
  end

  test "should create geo_municipality" do
    assert_difference("GeoMunicipality.count") do
      post geo_municipalities_url, params: { geo_municipality: { geo_provice_id: @geo_municipality.geo_provice_id, geo_region_id: @geo_municipality.geo_region_id } }
    end

    assert_redirected_to geo_municipality_url(GeoMunicipality.last)
  end

  test "should show geo_municipality" do
    get geo_municipality_url(@geo_municipality)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_municipality_url(@geo_municipality)
    assert_response :success
  end

  test "should update geo_municipality" do
    patch geo_municipality_url(@geo_municipality), params: { geo_municipality: { geo_provice_id: @geo_municipality.geo_provice_id, geo_region_id: @geo_municipality.geo_region_id } }
    assert_redirected_to geo_municipality_url(@geo_municipality)
  end

  test "should destroy geo_municipality" do
    assert_difference("GeoMunicipality.count", -1) do
      delete geo_municipality_url(@geo_municipality)
    end

    assert_redirected_to geo_municipalities_url
  end
end
