require "test_helper"

class UnderwritingRoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @underwriting_route = underwriting_routes(:one)
  end

  test "should get index" do
    get underwriting_routes_url
    assert_response :success
  end

  test "should get new" do
    get new_underwriting_route_url
    assert_response :success
  end

  test "should create underwriting_route" do
    assert_difference("UnderwritingRoute.count") do
      post underwriting_routes_url, params: { underwriting_route: { description: @underwriting_route.description, name: @underwriting_route.name } }
    end

    assert_redirected_to underwriting_route_url(UnderwritingRoute.last)
  end

  test "should show underwriting_route" do
    get underwriting_route_url(@underwriting_route)
    assert_response :success
  end

  test "should get edit" do
    get edit_underwriting_route_url(@underwriting_route)
    assert_response :success
  end

  test "should update underwriting_route" do
    patch underwriting_route_url(@underwriting_route), params: { underwriting_route: { description: @underwriting_route.description, name: @underwriting_route.name } }
    assert_redirected_to underwriting_route_url(@underwriting_route)
  end

  test "should destroy underwriting_route" do
    assert_difference("UnderwritingRoute.count", -1) do
      delete underwriting_route_url(@underwriting_route)
    end

    assert_redirected_to underwriting_routes_url
  end
end
