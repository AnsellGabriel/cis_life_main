require "test_helper"

class ProcessRemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @process_remark = process_remarks(:one)
  end

  test "should get index" do
    get process_remarks_url
    assert_response :success
  end

  test "should get new" do
    get new_process_remark_url
    assert_response :success
  end

  test "should create process_remark" do
    assert_difference("ProcessRemark.count") do
      post process_remarks_url, params: { process_remark: { process_coverage_id: @process_remark.process_coverage_id, remark: @process_remark.remark, status: @process_remark.status, user_id: @process_remark.user_id, user_type: @process_remark.user_type } }
    end

    assert_redirected_to process_remark_url(ProcessRemark.last)
  end

  test "should show process_remark" do
    get process_remark_url(@process_remark)
    assert_response :success
  end

  test "should get edit" do
    get edit_process_remark_url(@process_remark)
    assert_response :success
  end

  test "should update process_remark" do
    patch process_remark_url(@process_remark), params: { process_remark: { process_coverage_id: @process_remark.process_coverage_id, remark: @process_remark.remark, status: @process_remark.status, user_id: @process_remark.user_id, user_type: @process_remark.user_type } }
    assert_redirected_to process_remark_url(@process_remark)
  end

  test "should destroy process_remark" do
    assert_difference("ProcessRemark.count", -1) do
      delete process_remark_url(@process_remark)
    end

    assert_redirected_to process_remarks_url
  end
end
