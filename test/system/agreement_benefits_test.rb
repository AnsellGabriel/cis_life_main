require "application_system_test_case"

class AgreementBenefitsTest < ApplicationSystemTestCase
  setup do
    @agreement_benefit = agreement_benefits(:one)
  end

  test "visiting the index" do
    visit agreement_benefits_url
    assert_selector "h1", text: "Agreement benefits"
  end

  test "should create agreement benefit" do
    visit agreement_benefits_url
    click_on "New agreement benefit"

    fill_in "Agreement", with: @agreement_benefit.agreement_id
    fill_in "Description", with: @agreement_benefit.description
    fill_in "Insured type", with: @agreement_benefit.insured_type
    fill_in "Max age", with: @agreement_benefit.max_age
    fill_in "Min age", with: @agreement_benefit.min_age
    fill_in "Name", with: @agreement_benefit.name
    fill_in "Option", with: @agreement_benefit.option_id
    fill_in "Plan", with: @agreement_benefit.plan_id
    fill_in "Proposal", with: @agreement_benefit.proposal_id
    click_on "Create Agreement benefit"

    assert_text "Agreement benefit was successfully created"
    click_on "Back"
  end

  test "should update Agreement benefit" do
    visit agreement_benefit_url(@agreement_benefit)
    click_on "Edit this agreement benefit", match: :first

    fill_in "Agreement", with: @agreement_benefit.agreement_id
    fill_in "Description", with: @agreement_benefit.description
    fill_in "Insured type", with: @agreement_benefit.insured_type
    fill_in "Max age", with: @agreement_benefit.max_age
    fill_in "Min age", with: @agreement_benefit.min_age
    fill_in "Name", with: @agreement_benefit.name
    fill_in "Option", with: @agreement_benefit.option_id
    fill_in "Plan", with: @agreement_benefit.plan_id
    fill_in "Proposal", with: @agreement_benefit.proposal_id
    click_on "Update Agreement benefit"

    assert_text "Agreement benefit was successfully updated"
    click_on "Back"
  end

  test "should destroy Agreement benefit" do
    visit agreement_benefit_url(@agreement_benefit)
    click_on "Destroy this agreement benefit", match: :first

    assert_text "Agreement benefit was successfully destroyed"
  end
end
