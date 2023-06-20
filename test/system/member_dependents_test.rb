require "application_system_test_case"

class MemberDependentsTest < ApplicationSystemTestCase
  setup do
    @member_dependent = member_dependents(:one)
  end

  test "visiting the index" do
    visit member_dependents_url
    assert_selector "h1", text: "Member dependents"
  end

  test "should create member dependent" do
    visit member_dependents_url
    click_on "New member dependent"

    fill_in "Birth date", with: @member_dependent.birth_date
    fill_in "First name", with: @member_dependent.first_name
    fill_in "Last name", with: @member_dependent.last_name
    fill_in "Member", with: @member_dependent.member_id
    fill_in "Middle name", with: @member_dependent.middle_name
    fill_in "Relationship", with: @member_dependent.relationship
    fill_in "Suffix", with: @member_dependent.suffix
    click_on "Create Member dependent"

    assert_text "Member dependent was successfully created"
    click_on "Back"
  end

  test "should update Member dependent" do
    visit member_dependent_url(@member_dependent)
    click_on "Edit this member dependent", match: :first

    fill_in "Birth date", with: @member_dependent.birth_date
    fill_in "First name", with: @member_dependent.first_name
    fill_in "Last name", with: @member_dependent.last_name
    fill_in "Member", with: @member_dependent.member_id
    fill_in "Middle name", with: @member_dependent.middle_name
    fill_in "Relationship", with: @member_dependent.relationship
    fill_in "Suffix", with: @member_dependent.suffix
    click_on "Update Member dependent"

    assert_text "Member dependent was successfully updated"
    click_on "Back"
  end

  test "should destroy Member dependent" do
    visit member_dependent_url(@member_dependent)
    click_on "Destroy this member dependent", match: :first

    assert_text "Member dependent was successfully destroyed"
  end
end
