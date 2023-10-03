require "test_helper"

class PlanUnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan_unit = plan_units(:one)
  end

  test "should get index" do
    get plan_units_url
    assert_response :success
  end

  test "should get new" do
    get new_plan_unit_url
    assert_response :success
  end

  test "should create plan_unit" do
    assert_difference("PlanUnit.count") do
      post plan_units_url, params: { plan_unit: { name: @plan_unit.name, plan_id: @plan_unit.plan_id, total_prem: @plan_unit.total_prem } }
    end

    assert_redirected_to plan_unit_url(PlanUnit.last)
  end

  test "should show plan_unit" do
    get plan_unit_url(@plan_unit)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_unit_url(@plan_unit)
    assert_response :success
  end

  test "should update plan_unit" do
    patch plan_unit_url(@plan_unit), params: { plan_unit: { name: @plan_unit.name, plan_id: @plan_unit.plan_id, total_prem: @plan_unit.total_prem } }
    assert_redirected_to plan_unit_url(@plan_unit)
  end

  test "should destroy plan_unit" do
    assert_difference("PlanUnit.count", -1) do
      delete plan_unit_url(@plan_unit)
    end

    assert_redirected_to plan_units_url
  end
end
