require "test_helper"

class ProcessRoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @process_route = process_routes(:one)
  end

  test "should get index" do
    get process_routes_url
    assert_response :success
  end

  test "should get new" do
    get new_process_route_url
    assert_response :success
  end

  test "should create process_route" do
    assert_difference("ProcessRoute.count") do
      post process_routes_url, params: { process_route: { department: @process_route.department, description: @process_route.description, name: @process_route.name } }
    end

    assert_redirected_to process_route_url(ProcessRoute.last)
  end

  test "should show process_route" do
    get process_route_url(@process_route)
    assert_response :success
  end

  test "should get edit" do
    get edit_process_route_url(@process_route)
    assert_response :success
  end

  test "should update process_route" do
    patch process_route_url(@process_route), params: { process_route: { department: @process_route.department, description: @process_route.description, name: @process_route.name } }
    assert_redirected_to process_route_url(@process_route)
  end

  test "should destroy process_route" do
    assert_difference("ProcessRoute.count", -1) do
      delete process_route_url(@process_route)
    end

    assert_redirected_to process_routes_url
  end
end
