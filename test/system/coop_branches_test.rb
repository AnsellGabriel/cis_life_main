require "application_system_test_case"

class CoopBranchesTest < ApplicationSystemTestCase
  setup do
    @coop_branch = coop_branches(:one)
  end

  test "visiting the index" do
    visit coop_branches_url
    assert_selector "h1", text: "Coop branches"
  end

  test "should create coop branch" do
    visit coop_branches_url
    click_on "New coop branch"

    fill_in "Barangay", with: @coop_branch.barangay
    fill_in "Contact details", with: @coop_branch.contact_details
    fill_in "Cooperative", with: @coop_branch.cooperative_id
    fill_in "Municipality", with: @coop_branch.municipality
    fill_in "Name", with: @coop_branch.name
    fill_in "Province", with: @coop_branch.province
    fill_in "Region", with: @coop_branch.region
    click_on "Create Coop branch"

    assert_text "Coop branch was successfully created"
    click_on "Back"
  end

  test "should update Coop branch" do
    visit coop_branch_url(@coop_branch)
    click_on "Edit this coop branch", match: :first

    fill_in "Barangay", with: @coop_branch.barangay
    fill_in "Contact details", with: @coop_branch.contact_details
    fill_in "Cooperative", with: @coop_branch.cooperative_id
    fill_in "Municipality", with: @coop_branch.municipality
    fill_in "Name", with: @coop_branch.name
    fill_in "Province", with: @coop_branch.province
    fill_in "Region", with: @coop_branch.region
    click_on "Update Coop branch"

    assert_text "Coop branch was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop branch" do
    visit coop_branch_url(@coop_branch)
    click_on "Destroy this coop branch", match: :first

    assert_text "Coop branch was successfully destroyed"
  end
end
