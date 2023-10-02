require "test_helper"

class UnitBenefitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unit_benefit = unit_benefits(:one)
  end

  test "should get index" do
    get unit_benefits_url
    assert_response :success
  end

  test "should get new" do
    get new_unit_benefit_url
    assert_response :success
  end

  test "should create unit_benefit" do
    assert_difference("UnitBenefit.count") do
      post unit_benefits_url, params: { unit_benefit: { benefit_id: @unit_benefit.benefit_id, coverage_amount: @unit_benefit.coverage_amount, plan_unit_id: @unit_benefit.plan_unit_id } }
    end

    assert_redirected_to unit_benefit_url(UnitBenefit.last)
  end

  test "should show unit_benefit" do
    get unit_benefit_url(@unit_benefit)
    assert_response :success
  end

  test "should get edit" do
    get edit_unit_benefit_url(@unit_benefit)
    assert_response :success
  end

  test "should update unit_benefit" do
    patch unit_benefit_url(@unit_benefit), params: { unit_benefit: { benefit_id: @unit_benefit.benefit_id, coverage_amount: @unit_benefit.coverage_amount, plan_unit_id: @unit_benefit.plan_unit_id } }
    assert_redirected_to unit_benefit_url(@unit_benefit)
  end

  test "should destroy unit_benefit" do
    assert_difference("UnitBenefit.count", -1) do
      delete unit_benefit_url(@unit_benefit)
    end

    assert_redirected_to unit_benefits_url
  end
end
