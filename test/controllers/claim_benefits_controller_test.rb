require "test_helper"

class ClaimBenefitsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_benefits_new_url
    assert_response :success
  end

  test "should get create" do
    get claim_benefits_create_url
    assert_response :success
  end

  test "should get edit" do
    get claim_benefits_edit_url
    assert_response :success
  end

  test "should get update" do
    get claim_benefits_update_url
    assert_response :success
  end
end
