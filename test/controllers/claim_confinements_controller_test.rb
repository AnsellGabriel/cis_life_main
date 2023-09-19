require "test_helper"

class ClaimConfinementsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get claim_confinements_new_url
    assert_response :success
  end

  test "should get edit" do
    get claim_confinements_edit_url
    assert_response :success
  end
end
