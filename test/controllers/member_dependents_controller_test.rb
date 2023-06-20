require "test_helper"

class MemberDependentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member_dependent = member_dependents(:one)
  end

  test "should get index" do
    get member_dependents_url
    assert_response :success
  end

  test "should get new" do
    get new_member_dependent_url
    assert_response :success
  end

  test "should create member_dependent" do
    assert_difference("MemberDependent.count") do
      post member_dependents_url, params: { member_dependent: { birth_date: @member_dependent.birth_date, first_name: @member_dependent.first_name, last_name: @member_dependent.last_name, member_id: @member_dependent.member_id, middle_name: @member_dependent.middle_name, relationship: @member_dependent.relationship, suffix: @member_dependent.suffix } }
    end

    assert_redirected_to member_dependent_url(MemberDependent.last)
  end

  test "should show member_dependent" do
    get member_dependent_url(@member_dependent)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_dependent_url(@member_dependent)
    assert_response :success
  end

  test "should update member_dependent" do
    patch member_dependent_url(@member_dependent), params: { member_dependent: { birth_date: @member_dependent.birth_date, first_name: @member_dependent.first_name, last_name: @member_dependent.last_name, member_id: @member_dependent.member_id, middle_name: @member_dependent.middle_name, relationship: @member_dependent.relationship, suffix: @member_dependent.suffix } }
    assert_redirected_to member_dependent_url(@member_dependent)
  end

  test "should destroy member_dependent" do
    assert_difference("MemberDependent.count", -1) do
      delete member_dependent_url(@member_dependent)
    end

    assert_redirected_to member_dependents_url
  end
end
