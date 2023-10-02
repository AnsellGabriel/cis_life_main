require "application_system_test_case"

class GroupProposalsTest < ApplicationSystemTestCase
  setup do
    @group_proposal = group_proposals(:one)
  end

  test "visiting the index" do
    visit group_proposals_url
    assert_selector "h1", text: "Group proposals"
  end

  test "should create group proposal" do
    visit group_proposals_url
    click_on "New group proposal"

    fill_in "Cooperative", with: @group_proposal.cooperative_id
    fill_in "Plan", with: @group_proposal.plan_id
    fill_in "Plan unit", with: @group_proposal.plan_unit_id
    click_on "Create Group proposal"

    assert_text "Group proposal was successfully created"
    click_on "Back"
  end

  test "should update Group proposal" do
    visit group_proposal_url(@group_proposal)
    click_on "Edit this group proposal", match: :first

    fill_in "Cooperative", with: @group_proposal.cooperative_id
    fill_in "Plan", with: @group_proposal.plan_id
    fill_in "Plan unit", with: @group_proposal.plan_unit_id
    click_on "Update Group proposal"

    assert_text "Group proposal was successfully updated"
    click_on "Back"
  end

  test "should destroy Group proposal" do
    visit group_proposal_url(@group_proposal)
    click_on "Destroy this group proposal", match: :first

    assert_text "Group proposal was successfully destroyed"
  end
end
