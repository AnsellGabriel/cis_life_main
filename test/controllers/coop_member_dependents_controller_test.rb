require "test_helper"

class CoopMemberDependentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_member_dependent = coop_member_dependents(:one)
  end

  test "should get index" do
    get coop_member_dependents_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_member_dependent_url
    assert_response :success
  end

  test "should create coop_member_dependent" do
    assert_difference("CoopMemberDependent.count") do
      post coop_member_dependents_url, params: { coop_member_dependent: { birthdate: @coop_member_dependent.birthdate, coop_member_id: @coop_member_dependent.coop_member_id, first_name: @coop_member_dependent.first_name, last_name: @coop_member_dependent.last_name, middle_name: @coop_member_dependent.middle_name, relationship: @coop_member_dependent.relationship, suffix: @coop_member_dependent.suffix } }
    end

    assert_redirected_to coop_member_dependent_url(CoopMemberDependent.last)
  end

  test "should show coop_member_dependent" do
    get coop_member_dependent_url(@coop_member_dependent)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_member_dependent_url(@coop_member_dependent)
    assert_response :success
  end

  test "should update coop_member_dependent" do
    patch coop_member_dependent_url(@coop_member_dependent), params: { coop_member_dependent: { birthdate: @coop_member_dependent.birthdate, coop_member_id: @coop_member_dependent.coop_member_id, first_name: @coop_member_dependent.first_name, last_name: @coop_member_dependent.last_name, middle_name: @coop_member_dependent.middle_name, relationship: @coop_member_dependent.relationship, suffix: @coop_member_dependent.suffix } }
    assert_redirected_to coop_member_dependent_url(@coop_member_dependent)
  end

  test "should destroy coop_member_dependent" do
    assert_difference("CoopMemberDependent.count", -1) do
      delete coop_member_dependent_url(@coop_member_dependent)
    end

    assert_redirected_to coop_member_dependents_url
  end
end
