require "test_helper"

class ActuarialControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get actuarial_index_url
    assert_response :success
  end
end
