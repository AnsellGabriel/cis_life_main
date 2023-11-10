require "test_helper"

class CooperativesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cooperative = cooperatives(:one)
  end

  test "should get index" do
    get cooperatives_url
    assert_response :success
  end

  test "should get new" do
    get new_cooperative_url
    assert_response :success
  end

  test "should create cooperative" do
    assert_difference("Cooperative.count") do
      post cooperatives_url,
params: { cooperative: { acronym: @cooperative.acronym, contact_no: @cooperative.contact_no, coop_type_id: @cooperative.coop_type_id, description: @cooperative.description, email: @cooperative.email,
geo_barangay_id: @cooperative.geo_barangay_id, geo_municipality_id: @cooperative.geo_municipality_id, geo_province_id: @cooperative.geo_province_id, geo_region_id: @cooperative.geo_region_id, name: @cooperative.name, registration_no: @cooperative.registration_no, street: @cooperative.street, tin: @cooperative.tin } }
    end

    assert_redirected_to cooperative_url(Cooperative.last)
  end

  test "should show cooperative" do
    get cooperative_url(@cooperative)
    assert_response :success
  end

  test "should get edit" do
    get edit_cooperative_url(@cooperative)
    assert_response :success
  end

  test "should update cooperative" do
    patch cooperative_url(@cooperative),
params: { cooperative: { acronym: @cooperative.acronym, contact_no: @cooperative.contact_no, coop_type_id: @cooperative.coop_type_id, description: @cooperative.description, email: @cooperative.email,
geo_barangay_id: @cooperative.geo_barangay_id, geo_municipality_id: @cooperative.geo_municipality_id, geo_province_id: @cooperative.geo_province_id, geo_region_id: @cooperative.geo_region_id, name: @cooperative.name, registration_no: @cooperative.registration_no, street: @cooperative.street, tin: @cooperative.tin } }
    assert_redirected_to cooperative_url(@cooperative)
  end

  test "should destroy cooperative" do
    assert_difference("Cooperative.count", -1) do
      delete cooperative_url(@cooperative)
    end

    assert_redirected_to cooperatives_url
  end
end
