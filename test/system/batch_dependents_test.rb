require "application_system_test_case"

class BatchDependentsTest < ApplicationSystemTestCase
  setup do
    @batch_dependent = batch_dependents(:one)
  end

  test "visiting the index" do
    visit batch_dependents_url
    assert_selector "h1", text: "Batch dependents"
  end

  test "should create batch dependent" do
    visit batch_dependents_url
    click_on "New batch dependent"

    fill_in "Agreement benefit", with: @batch_dependent.agreement_benefit_id
    fill_in "Batch", with: @batch_dependent.batch_id
    fill_in "Coop dependent", with: @batch_dependent.coop_dependent_id
    fill_in "Premium", with: @batch_dependent.premium
    click_on "Create Batch dependent"

    assert_text "Batch dependent was successfully created"
    click_on "Back"
  end

  test "should update Batch dependent" do
    visit batch_dependent_url(@batch_dependent)
    click_on "Edit this batch dependent", match: :first

    fill_in "Agreement benefit", with: @batch_dependent.agreement_benefit_id
    fill_in "Batch", with: @batch_dependent.batch_id
    fill_in "Coop dependent", with: @batch_dependent.coop_dependent_id
    fill_in "Premium", with: @batch_dependent.premium
    click_on "Update Batch dependent"

    assert_text "Batch dependent was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch dependent" do
    visit batch_dependent_url(@batch_dependent)
    click_on "Destroy this batch dependent", match: :first

    assert_text "Batch dependent was successfully destroyed"
  end
end
