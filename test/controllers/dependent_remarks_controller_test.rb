require "test_helper"

class DependentRemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dependent_remark = dependent_remarks(:one)
  end

  test "should get index" do
    get dependent_remarks_url
    assert_response :success
  end

  test "should get new" do
    get new_dependent_remark_url
    assert_response :success
  end

  test "should create dependent_remark" do
    assert_difference("DependentRemark.count") do
      post dependent_remarks_url, params: { dependent_remark: { batch_dependent_id: @dependent_remark.batch_dependent_id, remark: @dependent_remark.remark, status: @dependent_remark.status } }
    end

    assert_redirected_to dependent_remark_url(DependentRemark.last)
  end

  test "should show dependent_remark" do
    get dependent_remark_url(@dependent_remark)
    assert_response :success
  end

  test "should get edit" do
    get edit_dependent_remark_url(@dependent_remark)
    assert_response :success
  end

  test "should update dependent_remark" do
    patch dependent_remark_url(@dependent_remark), params: { dependent_remark: { batch_dependent_id: @dependent_remark.batch_dependent_id, remark: @dependent_remark.remark, status: @dependent_remark.status } }
    assert_redirected_to dependent_remark_url(@dependent_remark)
  end

  test "should destroy dependent_remark" do
    assert_difference("DependentRemark.count", -1) do
      delete dependent_remark_url(@dependent_remark)
    end

    assert_redirected_to dependent_remarks_url
  end
end
