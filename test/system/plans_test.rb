require "application_system_test_case"

class PlansTest < ApplicationSystemTestCase
  setup do
    @plan = plans(:one)
  end

  test "visiting the index" do
    visit plans_url
    assert_selector "h1", text: "Plans"
  end

  test "should create plan" do
    visit plans_url
    click_on "New plan"

    fill_in "Acronym", with: @plan.acronym
    fill_in "Description", with: @plan.description
    fill_in "Entry age from", with: @plan.entry_age_from
    fill_in "Entry age to", with: @plan.entry_age_to
    fill_in "Exit age", with: @plan.exit_age
    fill_in "Min participation", with: @plan.min_participation
    fill_in "Name", with: @plan.name
    click_on "Create Plan"

    assert_text "Plan was successfully created"
    click_on "Back"
  end

  test "should update Plan" do
    visit plan_url(@plan)
    click_on "Edit this plan", match: :first

    fill_in "Acronym", with: @plan.acronym
    fill_in "Description", with: @plan.description
    fill_in "Entry age from", with: @plan.entry_age_from
    fill_in "Entry age to", with: @plan.entry_age_to
    fill_in "Exit age", with: @plan.exit_age
    fill_in "Min participation", with: @plan.min_participation
    fill_in "Name", with: @plan.name
    click_on "Update Plan"

    assert_text "Plan was successfully updated"
    click_on "Back"
  end

  test "should destroy Plan" do
    visit plan_url(@plan)
    click_on "Destroy this plan", match: :first

    assert_text "Plan was successfully destroyed"
  end
end
