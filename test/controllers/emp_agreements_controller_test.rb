require "test_helper"

class EmpAgreementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @emp_agreement = emp_agreements(:one)
  end

  test "should get index" do
    get emp_agreements_url
    assert_response :success
  end

  test "should get new" do
    get new_emp_agreement_url
    assert_response :success
  end

  test "should create emp_agreement" do
    assert_difference("EmpAgreement.count") do
      post emp_agreements_url, params: { emp_agreement: { agreement_id: @emp_agreement.agreement_id, employee_id: @emp_agreement.employee_id } }
    end

    assert_redirected_to emp_agreement_url(EmpAgreement.last)
  end

  test "should show emp_agreement" do
    get emp_agreement_url(@emp_agreement)
    assert_response :success
  end

  test "should get edit" do
    get edit_emp_agreement_url(@emp_agreement)
    assert_response :success
  end

  test "should update emp_agreement" do
    patch emp_agreement_url(@emp_agreement), params: { emp_agreement: { agreement_id: @emp_agreement.agreement_id, employee_id: @emp_agreement.employee_id } }
    assert_redirected_to emp_agreement_url(@emp_agreement)
  end

  test "should destroy emp_agreement" do
    assert_difference("EmpAgreement.count", -1) do
      delete emp_agreement_url(@emp_agreement)
    end

    assert_redirected_to emp_agreements_url
  end
end
