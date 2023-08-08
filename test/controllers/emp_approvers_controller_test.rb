require "test_helper"

class EmpApproversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @emp_approver = emp_approvers(:one)
  end

  test "should get index" do
    get emp_approvers_url
    assert_response :success
  end

  test "should get new" do
    get new_emp_approver_url
    assert_response :success
  end

  test "should create emp_approver" do
    assert_difference("EmpApprover.count") do
      post emp_approvers_url, params: { emp_approver: { approver_id: @emp_approver.approver_id, employee_id: @emp_approver.employee_id } }
    end

    assert_redirected_to emp_approver_url(EmpApprover.last)
  end

  test "should show emp_approver" do
    get emp_approver_url(@emp_approver)
    assert_response :success
  end

  test "should get edit" do
    get edit_emp_approver_url(@emp_approver)
    assert_response :success
  end

  test "should update emp_approver" do
    patch emp_approver_url(@emp_approver), params: { emp_approver: { approver_id: @emp_approver.approver_id, employee_id: @emp_approver.employee_id } }
    assert_redirected_to emp_approver_url(@emp_approver)
  end

  test "should destroy emp_approver" do
    assert_difference("EmpApprover.count", -1) do
      delete emp_approver_url(@emp_approver)
    end

    assert_redirected_to emp_approvers_url
  end
end
