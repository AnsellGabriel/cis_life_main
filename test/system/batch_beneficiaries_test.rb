require "application_system_test_case"

class BatchBeneficiariesTest < ApplicationSystemTestCase
  setup do
    @batch_beneficiary = batch_beneficiaries(:one)
  end

  test "visiting the index" do
    visit batch_beneficiaries_url
    assert_selector "h1", text: "Batch beneficiaries"
  end

  test "should create batch beneficiary" do
    visit batch_beneficiaries_url
    click_on "New batch beneficiary"

    fill_in "Batch", with: @batch_beneficiary.batch_id
    fill_in "Member dependent", with: @batch_beneficiary.member_dependent_id
    click_on "Create Batch beneficiary"

    assert_text "Batch beneficiary was successfully created"
    click_on "Back"
  end

  test "should update Batch beneficiary" do
    visit batch_beneficiary_url(@batch_beneficiary)
    click_on "Edit this batch beneficiary", match: :first

    fill_in "Batch", with: @batch_beneficiary.batch_id
    fill_in "Member dependent", with: @batch_beneficiary.member_dependent_id
    click_on "Update Batch beneficiary"

    assert_text "Batch beneficiary was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch beneficiary" do
    visit batch_beneficiary_url(@batch_beneficiary)
    click_on "Destroy this batch beneficiary", match: :first

    assert_text "Batch beneficiary was successfully destroyed"
  end
end
