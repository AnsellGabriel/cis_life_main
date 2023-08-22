require "test_helper"

class ClaimCoveragesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_coverages_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_coverages_edit_url
    assert_response :success
  end
end
