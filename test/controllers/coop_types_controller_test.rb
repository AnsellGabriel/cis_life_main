require "test_helper"

class CoopTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_type = coop_types(:one)
  end

  test "should get index" do
    get coop_types_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_type_url
    assert_response :success
  end

  test "should create coop_type" do
    assert_difference("CoopType.count") do
      post coop_types_url, params: { coop_type: { description: @coop_type.description, name: @coop_type.name } }
    end

    assert_redirected_to coop_type_url(CoopType.last)
  end

  test "should show coop_type" do
    get coop_type_url(@coop_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_type_url(@coop_type)
    assert_response :success
  end

  test "should update coop_type" do
    patch coop_type_url(@coop_type), params: { coop_type: { description: @coop_type.description, name: @coop_type.name } }
    assert_redirected_to coop_type_url(@coop_type)
  end

  test "should destroy coop_type" do
    assert_difference("CoopType.count", -1) do
      delete coop_type_url(@coop_type)
    end

    assert_redirected_to coop_types_url
  end
end
