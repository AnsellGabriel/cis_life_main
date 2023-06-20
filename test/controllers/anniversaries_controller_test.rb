require "test_helper"

class AnniversariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @anniversary = anniversaries(:one)
  end

  test "should get index" do
    get anniversaries_url
    assert_response :success
  end

  test "should get new" do
    get new_anniversary_url
    assert_response :success
  end

  test "should create anniversary" do
    assert_difference("Anniversary.count") do
      post anniversaries_url, params: { anniversary: { anniversary_date: @anniversary.anniversary_date, name: @anniversary.name } }
    end

    assert_redirected_to anniversary_url(Anniversary.last)
  end

  test "should show anniversary" do
    get anniversary_url(@anniversary)
    assert_response :success
  end

  test "should get edit" do
    get edit_anniversary_url(@anniversary)
    assert_response :success
  end

  test "should update anniversary" do
    patch anniversary_url(@anniversary), params: { anniversary: { anniversary_date: @anniversary.anniversary_date, name: @anniversary.name } }
    assert_redirected_to anniversary_url(@anniversary)
  end

  test "should destroy anniversary" do
    assert_difference("Anniversary.count", -1) do
      delete anniversary_url(@anniversary)
    end

    assert_redirected_to anniversaries_url
  end
end
