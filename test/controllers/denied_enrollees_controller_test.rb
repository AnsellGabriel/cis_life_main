require "test_helper"

class DeniedEnrolleesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get denied_enrollees_index_url
    assert_response :success
  end
end
