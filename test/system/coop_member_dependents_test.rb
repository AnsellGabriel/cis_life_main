require "application_system_test_case"

class CoopMemberDependentsTest < ApplicationSystemTestCase
  setup do
    @coop_member_dependent = coop_member_dependents(:one)
  end

  test "visiting the index" do
    visit coop_member_dependents_url
    assert_selector "h1", text: "Coop member dependents"
  end

  test "should create coop member dependent" do
    visit coop_member_dependents_url
    click_on "New coop member dependent"

    fill_in "Birthdate", with: @coop_member_dependent.birthdate
    fill_in "Coop member", with: @coop_member_dependent.coop_member_id
    fill_in "First name", with: @coop_member_dependent.first_name
    fill_in "Last name", with: @coop_member_dependent.last_name
    fill_in "Middle name", with: @coop_member_dependent.middle_name
    fill_in "Relationship", with: @coop_member_dependent.relationship
    fill_in "Suffix", with: @coop_member_dependent.suffix
    click_on "Create Coop member dependent"

    assert_text "Coop member dependent was successfully created"
    click_on "Back"
  end

  test "should update Coop member dependent" do
    visit coop_member_dependent_url(@coop_member_dependent)
    click_on "Edit this coop member dependent", match: :first

    fill_in "Birthdate", with: @coop_member_dependent.birthdate
    fill_in "Coop member", with: @coop_member_dependent.coop_member_id
    fill_in "First name", with: @coop_member_dependent.first_name
    fill_in "Last name", with: @coop_member_dependent.last_name
    fill_in "Middle name", with: @coop_member_dependent.middle_name
    fill_in "Relationship", with: @coop_member_dependent.relationship
    fill_in "Suffix", with: @coop_member_dependent.suffix
    click_on "Update Coop member dependent"

    assert_text "Coop member dependent was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop member dependent" do
    visit coop_member_dependent_url(@coop_member_dependent)
    click_on "Destroy this coop member dependent", match: :first

    assert_text "Coop member dependent was successfully destroyed"
  end
end
