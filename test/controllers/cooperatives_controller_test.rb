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
      post cooperatives_url, params: { cooperative: { barangay: @cooperative.barangay, contact_details: @cooperative.contact_details, municipality: @cooperative.municipality, name: @cooperative.name, province: @cooperative.province, region: @cooperative.region } }
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
    patch cooperative_url(@cooperative), params: { cooperative: { barangay: @cooperative.barangay, contact_details: @cooperative.contact_details, municipality: @cooperative.municipality, name: @cooperative.name, province: @cooperative.province, region: @cooperative.region } }
    assert_redirected_to cooperative_url(@cooperative)
  end

  test "should destroy cooperative" do
    assert_difference("Cooperative.count", -1) do
      delete cooperative_url(@cooperative)
    end

    assert_redirected_to cooperatives_url
  end
end
