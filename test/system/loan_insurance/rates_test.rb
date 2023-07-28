require "application_system_test_case"

class LoanInsurance::RatesTest < ApplicationSystemTestCase
  setup do
    @loan_insurance_rate = loan_insurance_rates(:one)
  end

  test "visiting the index" do
    visit loan_insurance_rates_url
    assert_selector "h1", text: "Rates"
  end

  test "should create rate" do
    visit loan_insurance_rates_url
    click_on "New rate"

    fill_in "Annual rate", with: @loan_insurance_rate.annual_rate
    fill_in "Daily rate", with: @loan_insurance_rate.daily_rate
    fill_in "Max age", with: @loan_insurance_rate.max_age
    fill_in "Min age", with: @loan_insurance_rate.min_age
    fill_in "Monthly rate", with: @loan_insurance_rate.monthly_rate
    click_on "Create Rate"

    assert_text "Rate was successfully created"
    click_on "Back"
  end

  test "should update Rate" do
    visit loan_insurance_rate_url(@loan_insurance_rate)
    click_on "Edit this rate", match: :first

    fill_in "Annual rate", with: @loan_insurance_rate.annual_rate
    fill_in "Daily rate", with: @loan_insurance_rate.daily_rate
    fill_in "Max age", with: @loan_insurance_rate.max_age
    fill_in "Min age", with: @loan_insurance_rate.min_age
    fill_in "Monthly rate", with: @loan_insurance_rate.monthly_rate
    click_on "Update Rate"

    assert_text "Rate was successfully updated"
    click_on "Back"
  end

  test "should destroy Rate" do
    visit loan_insurance_rate_url(@loan_insurance_rate)
    click_on "Destroy this rate", match: :first

    assert_text "Rate was successfully destroyed"
  end
end
