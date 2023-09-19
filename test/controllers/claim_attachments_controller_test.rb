require "test_helper"

class ClaimAttachmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_attachments_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_attachments_edit_url
    assert_response :success
  end
end
