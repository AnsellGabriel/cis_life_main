require "test_helper"

class CoopMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_member = coop_members(:one)
  end

  test "should get index" do
    get coop_members_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_member_url
    assert_response :success
  end

  test "should create coop_member" do
    assert_difference("CoopMember.count") do
      post coop_members_url, params: { coop_member: { birthdate: @coop_member.birthdate, coop_branch_id: @coop_member.coop_branch_id, cooperative_id: @coop_member.cooperative_id, email: @coop_member.email, first_name: @coop_member.first_name, last_name: @coop_member.last_name, middle_name: @coop_member.middle_name, mobile_number: @coop_member.mobile_number, suffix: @coop_member.suffix } }
    end

    assert_redirected_to coop_member_url(CoopMember.last)
  end

  test "should show coop_member" do
    get coop_member_url(@coop_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_member_url(@coop_member)
    assert_response :success
  end

  test "should update coop_member" do
    patch coop_member_url(@coop_member), params: { coop_member: { birthdate: @coop_member.birthdate, coop_branch_id: @coop_member.coop_branch_id, cooperative_id: @coop_member.cooperative_id, email: @coop_member.email, first_name: @coop_member.first_name, last_name: @coop_member.last_name, middle_name: @coop_member.middle_name, mobile_number: @coop_member.mobile_number, suffix: @coop_member.suffix } }
    assert_redirected_to coop_member_url(@coop_member)
  end

  test "should destroy coop_member" do
    assert_difference("CoopMember.count", -1) do
      delete coop_member_url(@coop_member)
    end

    assert_redirected_to coop_members_url
  end
end
