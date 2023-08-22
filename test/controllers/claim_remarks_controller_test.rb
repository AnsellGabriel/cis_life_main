require "test_helper"

class ClaimRemarksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_remarks_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_remarks_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get claim_remarks_destroy_url
    assert_response :success
  end
end
