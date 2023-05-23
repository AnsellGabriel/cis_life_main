require "test_helper"

class CoopUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_user = coop_users(:one)
  end

  test "should get index" do
    get coop_users_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_user_url
    assert_response :success
  end

  test "should create coop_user" do
    assert_difference("CoopUser.count") do
      post coop_users_url, params: { coop_user: {  } }
    end

    assert_redirected_to coop_user_url(CoopUser.last)
  end

  test "should show coop_user" do
    get coop_user_url(@coop_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_user_url(@coop_user)
    assert_response :success
  end

  test "should update coop_user" do
    patch coop_user_url(@coop_user), params: { coop_user: {  } }
    assert_redirected_to coop_user_url(@coop_user)
  end

  test "should destroy coop_user" do
    assert_difference("CoopUser.count", -1) do
      delete coop_user_url(@coop_user)
    end

    assert_redirected_to coop_users_url
  end
end
