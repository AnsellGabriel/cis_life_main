require "test_helper"

class GroupRemitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_remit = group_remits(:one)
  end

  test "should get index" do
    get group_remits_url
    assert_response :success
  end

  test "should get new" do
    get new_group_remit_url
    assert_response :success
  end

  test "should create group_remit" do
    assert_difference("GroupRemit.count") do
      post group_remits_url,
params: { group_remit: { agreement_id: @group_remit.agreement_id, anniversary_id: @group_remit.anniversary_id, description: @group_remit.description, name: @group_remit.name } }
    end

    assert_redirected_to group_remit_url(GroupRemit.last)
  end

  test "should show group_remit" do
    get group_remit_url(@group_remit)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_remit_url(@group_remit)
    assert_response :success
  end

  test "should update group_remit" do
    patch group_remit_url(@group_remit),
params: { group_remit: { agreement_id: @group_remit.agreement_id, anniversary_id: @group_remit.anniversary_id, description: @group_remit.description, name: @group_remit.name } }
    assert_redirected_to group_remit_url(@group_remit)
  end

  test "should destroy group_remit" do
    assert_difference("GroupRemit.count", -1) do
      delete group_remit_url(@group_remit)
    end

    assert_redirected_to group_remits_url
  end
end
