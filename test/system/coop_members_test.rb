require "application_system_test_case"

class CoopMembersTest < ApplicationSystemTestCase
  setup do
    @coop_member = coop_members(:one)
  end

  test "visiting the index" do
    visit coop_members_url
    assert_selector "h1", text: "Coop members"
  end

  test "should create coop member" do
    visit coop_members_url
    click_on "New coop member"

    fill_in "Birthdate", with: @coop_member.birthdate
    fill_in "Coop branch", with: @coop_member.coop_branch_id
    fill_in "Cooperative", with: @coop_member.cooperative_id
    fill_in "Email", with: @coop_member.email
    fill_in "First name", with: @coop_member.first_name
    fill_in "Last name", with: @coop_member.last_name
    fill_in "Middle name", with: @coop_member.middle_name
    fill_in "Mobile number", with: @coop_member.mobile_number
    fill_in "Suffix", with: @coop_member.suffix
    click_on "Create Coop member"

    assert_text "Coop member was successfully created"
    click_on "Back"
  end

  test "should update Coop member" do
    visit coop_member_url(@coop_member)
    click_on "Edit this coop member", match: :first

    fill_in "Birthdate", with: @coop_member.birthdate
    fill_in "Coop branch", with: @coop_member.coop_branch_id
    fill_in "Cooperative", with: @coop_member.cooperative_id
    fill_in "Email", with: @coop_member.email
    fill_in "First name", with: @coop_member.first_name
    fill_in "Last name", with: @coop_member.last_name
    fill_in "Middle name", with: @coop_member.middle_name
    fill_in "Mobile number", with: @coop_member.mobile_number
    fill_in "Suffix", with: @coop_member.suffix
    click_on "Update Coop member"

    assert_text "Coop member was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop member" do
    visit coop_member_url(@coop_member)
    click_on "Destroy this coop member", match: :first

    assert_text "Coop member was successfully destroyed"
  end
end
