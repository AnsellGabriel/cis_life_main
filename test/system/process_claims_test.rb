require "application_system_test_case"

class ProcessClaimsTest < ApplicationSystemTestCase
  setup do
    @process_claim = process_claims(:one)
  end

  test "visiting the index" do
    visit process_claims_url
    assert_selector "h1", text: "Process claims"
  end

  test "should create process claim" do
    visit process_claims_url
    click_on "New process claim"

    fill_in "Agreement", with: @process_claim.agreement_id
    fill_in "Batch", with: @process_claim.batch_id
    fill_in "Cooperative", with: @process_claim.cooperative_id
    fill_in "Date incident", with: @process_claim.date_incident
    fill_in "Entry type", with: @process_claim.entry_type
    click_on "Create Process claim"

    assert_text "Process claim was successfully created"
    click_on "Back"
  end

  test "should update Process claim" do
    visit process_claim_url(@process_claim)
    click_on "Edit this process claim", match: :first

    fill_in "Agreement", with: @process_claim.agreement_id
    fill_in "Batch", with: @process_claim.batch_id
    fill_in "Cooperative", with: @process_claim.cooperative_id
    fill_in "Date incident", with: @process_claim.date_incident
    fill_in "Entry type", with: @process_claim.entry_type
    click_on "Update Process claim"

    assert_text "Process claim was successfully updated"
    click_on "Back"
  end

  test "should destroy Process claim" do
    visit process_claim_url(@process_claim)
    click_on "Destroy this process claim", match: :first

    assert_text "Process claim was successfully destroyed"
  end
end
