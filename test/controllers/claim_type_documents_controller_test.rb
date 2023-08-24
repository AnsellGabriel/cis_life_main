require "test_helper"

class ClaimTypeDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_type_documents_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_type_documents_edit_url
    assert_response :success
  end
end
