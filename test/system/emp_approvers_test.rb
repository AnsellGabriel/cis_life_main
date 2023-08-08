require "application_system_test_case"

class EmpApproversTest < ApplicationSystemTestCase
  setup do
    @emp_approver = emp_approvers(:one)
  end

  test "visiting the index" do
    visit emp_approvers_url
    assert_selector "h1", text: "Emp approvers"
  end

  test "should create emp approver" do
    visit emp_approvers_url
    click_on "New emp approver"

    fill_in "Approver", with: @emp_approver.approver_id
    fill_in "Employee", with: @emp_approver.employee_id
    click_on "Create Emp approver"

    assert_text "Emp approver was successfully created"
    click_on "Back"
  end

  test "should update Emp approver" do
    visit emp_approver_url(@emp_approver)
    click_on "Edit this emp approver", match: :first

    fill_in "Approver", with: @emp_approver.approver_id
    fill_in "Employee", with: @emp_approver.employee_id
    click_on "Update Emp approver"

    assert_text "Emp approver was successfully updated"
    click_on "Back"
  end

  test "should destroy Emp approver" do
    visit emp_approver_url(@emp_approver)
    click_on "Destroy this emp approver", match: :first

    assert_text "Emp approver was successfully destroyed"
  end
end
