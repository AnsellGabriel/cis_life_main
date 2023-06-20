require "test_helper"

class CoopAgreementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_agreement = coop_agreements(:one)
  end

  test "should get index" do
    get coop_agreements_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_agreement_url
    assert_response :success
  end

  test "should create coop_agreement" do
    assert_difference("CoopAgreement.count") do
      post coop_agreements_url, params: { coop_agreement: {  } }
    end

    assert_redirected_to coop_agreement_url(CoopAgreement.last)
  end

  test "should show coop_agreement" do
    get coop_agreement_url(@coop_agreement)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_agreement_url(@coop_agreement)
    assert_response :success
  end

  test "should update coop_agreement" do
    patch coop_agreement_url(@coop_agreement), params: { coop_agreement: {  } }
    assert_redirected_to coop_agreement_url(@coop_agreement)
  end

  test "should destroy coop_agreement" do
    assert_difference("CoopAgreement.count", -1) do
      delete coop_agreement_url(@coop_agreement)
    end

    assert_redirected_to coop_agreements_url
  end
end
