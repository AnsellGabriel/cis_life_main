require "test_helper"

class DeniedDependentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @denied_dependent = denied_dependents(:one)
  end

  test "should get index" do
    get denied_dependents_url
    assert_response :success
  end

  test "should get new" do
    get new_denied_dependent_url
    assert_response :success
  end

  test "should create denied_dependent" do
    assert_difference("DeniedDependent.count") do
      post denied_dependents_url,
params: { denied_dependent: { age: @denied_dependent.age, group_remit_id: @denied_dependent.group_remit_id, name: @denied_dependent.name, reason: @denied_dependent.reason } }
    end

    assert_redirected_to denied_dependent_url(DeniedDependent.last)
  end

  test "should show denied_dependent" do
    get denied_dependent_url(@denied_dependent)
    assert_response :success
  end

  test "should get edit" do
    get edit_denied_dependent_url(@denied_dependent)
    assert_response :success
  end

  test "should update denied_dependent" do
    patch denied_dependent_url(@denied_dependent),
params: { denied_dependent: { age: @denied_dependent.age, group_remit_id: @denied_dependent.group_remit_id, name: @denied_dependent.name, reason: @denied_dependent.reason } }
    assert_redirected_to denied_dependent_url(@denied_dependent)
  end

  test "should destroy denied_dependent" do
    assert_difference("DeniedDependent.count", -1) do
      delete denied_dependent_url(@denied_dependent)
    end

    assert_redirected_to denied_dependents_url
  end
end
