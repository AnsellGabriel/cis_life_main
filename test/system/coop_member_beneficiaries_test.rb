require "application_system_test_case"

class CoopMemberBeneficiariesTest < ApplicationSystemTestCase
  setup do
    @coop_member_beneficiary = coop_member_beneficiaries(:one)
  end

  test "visiting the index" do
    visit coop_member_beneficiaries_url
    assert_selector "h1", text: "Coop member beneficiaries"
  end

  test "should create coop member beneficiary" do
    visit coop_member_beneficiaries_url
    click_on "New coop member beneficiary"

    fill_in "Birthdate", with: @coop_member_beneficiary.birthdate
    fill_in "Coop member", with: @coop_member_beneficiary.coop_member_id
    fill_in "First name", with: @coop_member_beneficiary.first_name
    fill_in "Last name", with: @coop_member_beneficiary.last_name
    fill_in "Middle name", with: @coop_member_beneficiary.middle_name
    fill_in "Relationship", with: @coop_member_beneficiary.relationship
    fill_in "Suffix", with: @coop_member_beneficiary.suffix
    click_on "Create Coop member beneficiary"

    assert_text "Coop member beneficiary was successfully created"
    click_on "Back"
  end

  test "should update Coop member beneficiary" do
    visit coop_member_beneficiary_url(@coop_member_beneficiary)
    click_on "Edit this coop member beneficiary", match: :first

    fill_in "Birthdate", with: @coop_member_beneficiary.birthdate
    fill_in "Coop member", with: @coop_member_beneficiary.coop_member_id
    fill_in "First name", with: @coop_member_beneficiary.first_name
    fill_in "Last name", with: @coop_member_beneficiary.last_name
    fill_in "Middle name", with: @coop_member_beneficiary.middle_name
    fill_in "Relationship", with: @coop_member_beneficiary.relationship
    fill_in "Suffix", with: @coop_member_beneficiary.suffix
    click_on "Update Coop member beneficiary"

    assert_text "Coop member beneficiary was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop member beneficiary" do
    visit coop_member_beneficiary_url(@coop_member_beneficiary)
    click_on "Destroy this coop member beneficiary", match: :first

    assert_text "Coop member beneficiary was successfully destroyed"
  end
end
