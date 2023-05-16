require "application_system_test_case"

class ProposalsTest < ApplicationSystemTestCase
  setup do
    @proposal = proposals(:one)
  end

  test "visiting the index" do
    visit proposals_url
    assert_selector "h1", text: "Proposals"
  end

  test "should create proposal" do
    visit proposals_url
    click_on "New proposal"

    fill_in "Agent sf", with: @proposal.agent_sf
    fill_in "Ave age", with: @proposal.ave_age
    fill_in "Coop sf", with: @proposal.coop_sf
    fill_in "Cooperative", with: @proposal.cooperative_id
    fill_in "Total premium", with: @proposal.total_premium
    click_on "Create Proposal"

    assert_text "Proposal was successfully created"
    click_on "Back"
  end

  test "should update Proposal" do
    visit proposal_url(@proposal)
    click_on "Edit this proposal", match: :first

    fill_in "Agent sf", with: @proposal.agent_sf
    fill_in "Ave age", with: @proposal.ave_age
    fill_in "Coop sf", with: @proposal.coop_sf
    fill_in "Cooperative", with: @proposal.cooperative_id
    fill_in "Total premium", with: @proposal.total_premium
    click_on "Update Proposal"

    assert_text "Proposal was successfully updated"
    click_on "Back"
  end

  test "should destroy Proposal" do
    visit proposal_url(@proposal)
    click_on "Destroy this proposal", match: :first

    assert_text "Proposal was successfully destroyed"
  end
end
