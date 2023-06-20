require "application_system_test_case"

class AgreementsTest < ApplicationSystemTestCase
  setup do
    @agreement = agreements(:one)
  end

  test "visiting the index" do
    visit agreements_url
    assert_selector "h1", text: "Agreements"
  end

  test "should create agreement" do
    visit agreements_url
    click_on "New agreement"

    fill_in "Agent", with: @agreement.agent_id
    fill_in "Anniversary type", with: @agreement.anniversary_type
    check "Claims fund" if @agreement.claims_fund
    fill_in "Comm type", with: @agreement.comm_type
    fill_in "Contestability", with: @agreement.contestability
    fill_in "Cooperative", with: @agreement.cooperative_id
    fill_in "Entry age from", with: @agreement.entry_age_from
    fill_in "Entry age to", with: @agreement.entry_age_to
    fill_in "Exit age", with: @agreement.exit_age
    fill_in "Moa no", with: @agreement.moa_no
    fill_in "Nel", with: @agreement.nel
    fill_in "Nml", with: @agreement.nml
    fill_in "Plan", with: @agreement.plan_id
    fill_in "Previous provider", with: @agreement.previous_provider
    check "Transferred" if @agreement.transferred
    fill_in "Transferred date", with: @agreement.transferred_date
    click_on "Create Agreement"

    assert_text "Agreement was successfully created"
    click_on "Back"
  end

  test "should update Agreement" do
    visit agreement_url(@agreement)
    click_on "Edit this agreement", match: :first

    fill_in "Agent", with: @agreement.agent_id
    fill_in "Anniversary type", with: @agreement.anniversary_type
    check "Claims fund" if @agreement.claims_fund
    fill_in "Comm type", with: @agreement.comm_type
    fill_in "Contestability", with: @agreement.contestability
    fill_in "Cooperative", with: @agreement.cooperative_id
    fill_in "Entry age from", with: @agreement.entry_age_from
    fill_in "Entry age to", with: @agreement.entry_age_to
    fill_in "Exit age", with: @agreement.exit_age
    fill_in "Moa no", with: @agreement.moa_no
    fill_in "Nel", with: @agreement.nel
    fill_in "Nml", with: @agreement.nml
    fill_in "Plan", with: @agreement.plan_id
    fill_in "Previous provider", with: @agreement.previous_provider
    check "Transferred" if @agreement.transferred
    fill_in "Transferred date", with: @agreement.transferred_date
    click_on "Update Agreement"

    assert_text "Agreement was successfully updated"
    click_on "Back"
  end

  test "should destroy Agreement" do
    visit agreement_url(@agreement)
    click_on "Destroy this agreement", match: :first

    assert_text "Agreement was successfully destroyed"
  end
end
