require "test_helper"

class CoopMemberBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_member_beneficiary = coop_member_beneficiaries(:one)
  end

  test "should get index" do
    get coop_member_beneficiaries_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_member_beneficiary_url
    assert_response :success
  end

  test "should create coop_member_beneficiary" do
    assert_difference("CoopMemberBeneficiary.count") do
      post coop_member_beneficiaries_url, params: { coop_member_beneficiary: { birthdate: @coop_member_beneficiary.birthdate, coop_member_id: @coop_member_beneficiary.coop_member_id, first_name: @coop_member_beneficiary.first_name, last_name: @coop_member_beneficiary.last_name, middle_name: @coop_member_beneficiary.middle_name, relationship: @coop_member_beneficiary.relationship, suffix: @coop_member_beneficiary.suffix } }
    end

    assert_redirected_to coop_member_beneficiary_url(CoopMemberBeneficiary.last)
  end

  test "should show coop_member_beneficiary" do
    get coop_member_beneficiary_url(@coop_member_beneficiary)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_member_beneficiary_url(@coop_member_beneficiary)
    assert_response :success
  end

  test "should update coop_member_beneficiary" do
    patch coop_member_beneficiary_url(@coop_member_beneficiary), params: { coop_member_beneficiary: { birthdate: @coop_member_beneficiary.birthdate, coop_member_id: @coop_member_beneficiary.coop_member_id, first_name: @coop_member_beneficiary.first_name, last_name: @coop_member_beneficiary.last_name, middle_name: @coop_member_beneficiary.middle_name, relationship: @coop_member_beneficiary.relationship, suffix: @coop_member_beneficiary.suffix } }
    assert_redirected_to coop_member_beneficiary_url(@coop_member_beneficiary)
  end

  test "should destroy coop_member_beneficiary" do
    assert_difference("CoopMemberBeneficiary.count", -1) do
      delete coop_member_beneficiary_url(@coop_member_beneficiary)
    end

    assert_redirected_to coop_member_beneficiaries_url
  end
end
