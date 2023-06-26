require "test_helper"

class BatchRemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch_remark = batch_remarks(:one)
  end

  test "should get index" do
    get batch_remarks_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_remark_url
    assert_response :success
  end

  test "should create batch_remark" do
    assert_difference("BatchRemark.count") do
      post batch_remarks_url, params: { batch_remark: { batch_id: @batch_remark.batch_id, remark: @batch_remark.remark, user_id: @batch_remark.user_id, user_type: @batch_remark.user_type } }
    end

    assert_redirected_to batch_remark_url(BatchRemark.last)
  end

  test "should show batch_remark" do
    get batch_remark_url(@batch_remark)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_remark_url(@batch_remark)
    assert_response :success
  end

  test "should update batch_remark" do
    patch batch_remark_url(@batch_remark), params: { batch_remark: { batch_id: @batch_remark.batch_id, remark: @batch_remark.remark, user_id: @batch_remark.user_id, user_type: @batch_remark.user_type } }
    assert_redirected_to batch_remark_url(@batch_remark)
  end

  test "should destroy batch_remark" do
    assert_difference("BatchRemark.count", -1) do
      delete batch_remark_url(@batch_remark)
    end

    assert_redirected_to batch_remarks_url
  end
end
