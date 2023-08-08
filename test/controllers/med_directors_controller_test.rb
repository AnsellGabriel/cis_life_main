require "test_helper"

class MedDirectorsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get med_directors_home_url
    assert_response :success
  end
end
