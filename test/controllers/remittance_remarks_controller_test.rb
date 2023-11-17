require "test_helper"

class RemittanceRemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @remittance_remark = remittance_remarks(:one)
  end

  test "should get index" do
    get remittance_remarks_url
    assert_response :success
  end

  test "should get new" do
    get new_remittance_remark_url
    assert_response :success
  end

  test "should create remittance_remark" do
    assert_difference("RemittanceRemark.count") do
      post remittance_remarks_url,
params: { remittance_remark: { group_remit_id: @remittance_remark.group_remit_id, payment_id: @remittance_remark.payment_id, remark: @remittance_remark.remark, status: @remittance_remark.status } }
    end

    assert_redirected_to remittance_remark_url(RemittanceRemark.last)
  end

  test "should show remittance_remark" do
    get remittance_remark_url(@remittance_remark)
    assert_response :success
  end

  test "should get edit" do
    get edit_remittance_remark_url(@remittance_remark)
    assert_response :success
  end

  test "should update remittance_remark" do
    patch remittance_remark_url(@remittance_remark),
params: { remittance_remark: { group_remit_id: @remittance_remark.group_remit_id, payment_id: @remittance_remark.payment_id, remark: @remittance_remark.remark, status: @remittance_remark.status } }
    assert_redirected_to remittance_remark_url(@remittance_remark)
  end

  test "should destroy remittance_remark" do
    assert_difference("RemittanceRemark.count", -1) do
      delete remittance_remark_url(@remittance_remark)
    end

    assert_redirected_to remittance_remarks_url
  end
end
