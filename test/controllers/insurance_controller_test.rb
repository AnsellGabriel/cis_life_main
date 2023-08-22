require "test_helper"

class InsuranceControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get insurance_destroy_url
    assert_response :success
  end
end
