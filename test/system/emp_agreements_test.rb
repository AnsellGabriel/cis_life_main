require "application_system_test_case"

class EmpAgreementsTest < ApplicationSystemTestCase
  setup do
    @emp_agreement = emp_agreements(:one)
  end

  test "visiting the index" do
    visit emp_agreements_url
    assert_selector "h1", text: "Emp agreements"
  end

  test "should create emp agreement" do
    visit emp_agreements_url
    click_on "New emp agreement"

    fill_in "Agreement", with: @emp_agreement.agreement_id
    fill_in "Employee", with: @emp_agreement.employee_id
    click_on "Create Emp agreement"

    assert_text "Emp agreement was successfully created"
    click_on "Back"
  end

  test "should update Emp agreement" do
    visit emp_agreement_url(@emp_agreement)
    click_on "Edit this emp agreement", match: :first

    fill_in "Agreement", with: @emp_agreement.agreement_id
    fill_in "Employee", with: @emp_agreement.employee_id
    click_on "Update Emp agreement"

    assert_text "Emp agreement was successfully updated"
    click_on "Back"
  end

  test "should destroy Emp agreement" do
    visit emp_agreement_url(@emp_agreement)
    click_on "Destroy this emp agreement", match: :first

    assert_text "Emp agreement was successfully destroyed"
  end
end
