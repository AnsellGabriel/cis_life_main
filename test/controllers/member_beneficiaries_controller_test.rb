require "test_helper"

class MemberBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member_beneficiary = member_beneficiaries(:one)
  end

  test "should get index" do
    get member_beneficiaries_url
    assert_response :success
  end

  test "should get new" do
    get new_member_beneficiary_url
    assert_response :success
  end

  test "should create member_beneficiary" do
    assert_difference("MemberBeneficiary.count") do
      post member_beneficiaries_url, params: { member_beneficiary: { batch_id: @member_beneficiary.batch_id, birth_date: @member_beneficiary.birth_date, first_name: @member_beneficiary.first_name, last_name: @member_beneficiary.last_name, member_id: @member_beneficiary.member_id, middle_name: @member_beneficiary.middle_name, relationship: @member_beneficiary.relationship, suffix: @member_beneficiary.suffix } }
    end

    assert_redirected_to member_beneficiary_url(MemberBeneficiary.last)
  end

  test "should show member_beneficiary" do
    get member_beneficiary_url(@member_beneficiary)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_beneficiary_url(@member_beneficiary)
    assert_response :success
  end

  test "should update member_beneficiary" do
    patch member_beneficiary_url(@member_beneficiary), params: { member_beneficiary: { batch_id: @member_beneficiary.batch_id, birth_date: @member_beneficiary.birth_date, first_name: @member_beneficiary.first_name, last_name: @member_beneficiary.last_name, member_id: @member_beneficiary.member_id, middle_name: @member_beneficiary.middle_name, relationship: @member_beneficiary.relationship, suffix: @member_beneficiary.suffix } }
    assert_redirected_to member_beneficiary_url(@member_beneficiary)
  end

  test "should destroy member_beneficiary" do
    assert_difference("MemberBeneficiary.count", -1) do
      delete member_beneficiary_url(@member_beneficiary)
    end

    assert_redirected_to member_beneficiaries_url
  end
end
