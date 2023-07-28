require "application_system_test_case"

class LoanInsurance::RetentionsTest < ApplicationSystemTestCase
  setup do
    @loan_insurance_retention = loan_insurance_retentions(:one)
  end

  test "visiting the index" do
    visit loan_insurance_retentions_url
    assert_selector "h1", text: "Retentions"
  end

  test "should create retention" do
    visit loan_insurance_retentions_url
    click_on "New retention"

    check "Active" if @loan_insurance_retention.active
    fill_in "Amount", with: @loan_insurance_retention.amount
    fill_in "Date activated", with: @loan_insurance_retention.date_activated
    fill_in "Date deactivated", with: @loan_insurance_retention.date_deactivated
    click_on "Create Retention"

    assert_text "Retention was successfully created"
    click_on "Back"
  end

  test "should update Retention" do
    visit loan_insurance_retention_url(@loan_insurance_retention)
    click_on "Edit this retention", match: :first

    check "Active" if @loan_insurance_retention.active
    fill_in "Amount", with: @loan_insurance_retention.amount
    fill_in "Date activated", with: @loan_insurance_retention.date_activated
    fill_in "Date deactivated", with: @loan_insurance_retention.date_deactivated
    click_on "Update Retention"

    assert_text "Retention was successfully updated"
    click_on "Back"
  end

  test "should destroy Retention" do
    visit loan_insurance_retention_url(@loan_insurance_retention)
    click_on "Destroy this retention", match: :first

    assert_text "Retention was successfully destroyed"
  end
end
