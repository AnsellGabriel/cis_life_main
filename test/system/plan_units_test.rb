require "application_system_test_case"

class PlanUnitsTest < ApplicationSystemTestCase
  setup do
    @plan_unit = plan_units(:one)
  end

  test "visiting the index" do
    visit plan_units_url
    assert_selector "h1", text: "Plan units"
  end

  test "should create plan unit" do
    visit plan_units_url
    click_on "New plan unit"

    fill_in "Name", with: @plan_unit.name
    fill_in "Plan", with: @plan_unit.plan_id
    fill_in "Total prem", with: @plan_unit.total_prem
    click_on "Create Plan unit"

    assert_text "Plan unit was successfully created"
    click_on "Back"
  end

  test "should update Plan unit" do
    visit plan_unit_url(@plan_unit)
    click_on "Edit this plan unit", match: :first

    fill_in "Name", with: @plan_unit.name
    fill_in "Plan", with: @plan_unit.plan_id
    fill_in "Total prem", with: @plan_unit.total_prem
    click_on "Update Plan unit"

    assert_text "Plan unit was successfully updated"
    click_on "Back"
  end

  test "should destroy Plan unit" do
    visit plan_unit_url(@plan_unit)
    click_on "Destroy this plan unit", match: :first

    assert_text "Plan unit was successfully destroyed"
  end
end
