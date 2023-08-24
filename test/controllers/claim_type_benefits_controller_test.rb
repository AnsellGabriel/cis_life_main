require "test_helper"

class ClaimTypeBenefitsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_type_benefits_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_type_benefits_edit_url
    assert_response :success
  end
end
