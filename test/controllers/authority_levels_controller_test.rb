require "test_helper"

class AuthorityLevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authority_level = authority_levels(:one)
  end

  test "should get index" do
    get authority_levels_url
    assert_response :success
  end

  test "should get new" do
    get new_authority_level_url
    assert_response :success
  end

  test "should create authority_level" do
    assert_difference("AuthorityLevel.count") do
      post authority_levels_url, params: { authority_level: { maxAmount: @authority_level.maxAmount, name: @authority_level.name } }
    end

    assert_redirected_to authority_level_url(AuthorityLevel.last)
  end

  test "should show authority_level" do
    get authority_level_url(@authority_level)
    assert_response :success
  end

  test "should get edit" do
    get edit_authority_level_url(@authority_level)
    assert_response :success
  end

  test "should update authority_level" do
    patch authority_level_url(@authority_level), params: { authority_level: { maxAmount: @authority_level.maxAmount, name: @authority_level.name } }
    assert_redirected_to authority_level_url(@authority_level)
  end

  test "should destroy authority_level" do
    assert_difference("AuthorityLevel.count", -1) do
      delete authority_level_url(@authority_level)
    end

    assert_redirected_to authority_levels_url
  end
end
