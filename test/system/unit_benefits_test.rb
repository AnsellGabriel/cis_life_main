require "application_system_test_case"

class UnitBenefitsTest < ApplicationSystemTestCase
  setup do
    @unit_benefit = unit_benefits(:one)
  end

  test "visiting the index" do
    visit unit_benefits_url
    assert_selector "h1", text: "Unit benefits"
  end

  test "should create unit benefit" do
    visit unit_benefits_url
    click_on "New unit benefit"

    fill_in "Benefit", with: @unit_benefit.benefit_id
    fill_in "Coverage amount", with: @unit_benefit.coverage_amount
    fill_in "Plan unit", with: @unit_benefit.plan_unit_id
    click_on "Create Unit benefit"

    assert_text "Unit benefit was successfully created"
    click_on "Back"
  end

  test "should update Unit benefit" do
    visit unit_benefit_url(@unit_benefit)
    click_on "Edit this unit benefit", match: :first

    fill_in "Benefit", with: @unit_benefit.benefit_id
    fill_in "Coverage amount", with: @unit_benefit.coverage_amount
    fill_in "Plan unit", with: @unit_benefit.plan_unit_id
    click_on "Update Unit benefit"

    assert_text "Unit benefit was successfully updated"
    click_on "Back"
  end

  test "should destroy Unit benefit" do
    visit unit_benefit_url(@unit_benefit)
    click_on "Destroy this unit benefit", match: :first

    assert_text "Unit benefit was successfully destroyed"
  end
end
