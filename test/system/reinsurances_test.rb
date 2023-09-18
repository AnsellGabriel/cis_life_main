require "application_system_test_case"

class ReinsurancesTest < ApplicationSystemTestCase
  setup do
    @reinsurance = reinsurances(:one)
  end

  test "visiting the index" do
    visit reinsurances_url
    assert_selector "h1", text: "Reinsurances"
  end

  test "should create reinsurance" do
    visit reinsurances_url
    click_on "New reinsurance"

    fill_in "Date from", with: @reinsurance.date_from
    fill_in "Date to", with: @reinsurance.date_to
    fill_in "Ri total amount", with: @reinsurance.ri_total_amount
    fill_in "Ri total prem", with: @reinsurance.ri_total_prem
    click_on "Create Reinsurance"

    assert_text "Reinsurance was successfully created"
    click_on "Back"
  end

  test "should update Reinsurance" do
    visit reinsurance_url(@reinsurance)
    click_on "Edit this reinsurance", match: :first

    fill_in "Date from", with: @reinsurance.date_from
    fill_in "Date to", with: @reinsurance.date_to
    fill_in "Ri total amount", with: @reinsurance.ri_total_amount
    fill_in "Ri total prem", with: @reinsurance.ri_total_prem
    click_on "Update Reinsurance"

    assert_text "Reinsurance was successfully updated"
    click_on "Back"
  end

  test "should destroy Reinsurance" do
    visit reinsurance_url(@reinsurance)
    click_on "Destroy this reinsurance", match: :first

    assert_text "Reinsurance was successfully destroyed"
  end
end
