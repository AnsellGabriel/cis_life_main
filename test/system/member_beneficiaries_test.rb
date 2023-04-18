require "application_system_test_case"

class MemberBeneficiariesTest < ApplicationSystemTestCase
  setup do
    @member_beneficiary = member_beneficiaries(:one)
  end

  test "visiting the index" do
    visit member_beneficiaries_url
    assert_selector "h1", text: "Member beneficiaries"
  end

  test "should create member beneficiary" do
    visit member_beneficiaries_url
    click_on "New member beneficiary"

    fill_in "Batch", with: @member_beneficiary.batch_id
    fill_in "Birth date", with: @member_beneficiary.birth_date
    fill_in "First name", with: @member_beneficiary.first_name
    fill_in "Last name", with: @member_beneficiary.last_name
    fill_in "Member", with: @member_beneficiary.member_id
    fill_in "Middle name", with: @member_beneficiary.middle_name
    fill_in "Relationship", with: @member_beneficiary.relationship
    fill_in "Suffix", with: @member_beneficiary.suffix
    click_on "Create Member beneficiary"

    assert_text "Member beneficiary was successfully created"
    click_on "Back"
  end

  test "should update Member beneficiary" do
    visit member_beneficiary_url(@member_beneficiary)
    click_on "Edit this member beneficiary", match: :first

    fill_in "Batch", with: @member_beneficiary.batch_id
    fill_in "Birth date", with: @member_beneficiary.birth_date
    fill_in "First name", with: @member_beneficiary.first_name
    fill_in "Last name", with: @member_beneficiary.last_name
    fill_in "Member", with: @member_beneficiary.member_id
    fill_in "Middle name", with: @member_beneficiary.middle_name
    fill_in "Relationship", with: @member_beneficiary.relationship
    fill_in "Suffix", with: @member_beneficiary.suffix
    click_on "Update Member beneficiary"

    assert_text "Member beneficiary was successfully updated"
    click_on "Back"
  end

  test "should destroy Member beneficiary" do
    visit member_beneficiary_url(@member_beneficiary)
    click_on "Destroy this member beneficiary", match: :first

    assert_text "Member beneficiary was successfully destroyed"
  end
end
