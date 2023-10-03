require "test_helper"

class GroupProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_proposal = group_proposals(:one)
  end

  test "should get index" do
    get group_proposals_url
    assert_response :success
  end

  test "should get new" do
    get new_group_proposal_url
    assert_response :success
  end

  test "should create group_proposal" do
    assert_difference("GroupProposal.count") do
      post group_proposals_url, params: { group_proposal: { cooperative_id: @group_proposal.cooperative_id, plan_id: @group_proposal.plan_id, plan_unit_id: @group_proposal.plan_unit_id } }
    end

    assert_redirected_to group_proposal_url(GroupProposal.last)
  end

  test "should show group_proposal" do
    get group_proposal_url(@group_proposal)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_proposal_url(@group_proposal)
    assert_response :success
  end

  test "should update group_proposal" do
    patch group_proposal_url(@group_proposal), params: { group_proposal: { cooperative_id: @group_proposal.cooperative_id, plan_id: @group_proposal.plan_id, plan_unit_id: @group_proposal.plan_unit_id } }
    assert_redirected_to group_proposal_url(@group_proposal)
  end

  test "should destroy group_proposal" do
    assert_difference("GroupProposal.count", -1) do
      delete group_proposal_url(@group_proposal)
    end

    assert_redirected_to group_proposals_url
  end
end
