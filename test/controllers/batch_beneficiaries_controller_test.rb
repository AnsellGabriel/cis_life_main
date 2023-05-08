require "test_helper"

class BatchBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch_beneficiary = batch_beneficiaries(:one)
  end

  test "should get index" do
    get batch_beneficiaries_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_beneficiary_url
    assert_response :success
  end

  test "should create batch_beneficiary" do
    assert_difference("BatchBeneficiary.count") do
      post batch_beneficiaries_url, params: { batch_beneficiary: { batch_id: @batch_beneficiary.batch_id, member_dependent_id: @batch_beneficiary.member_dependent_id } }
    end

    assert_redirected_to batch_beneficiary_url(BatchBeneficiary.last)
  end

  test "should show batch_beneficiary" do
    get batch_beneficiary_url(@batch_beneficiary)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_beneficiary_url(@batch_beneficiary)
    assert_response :success
  end

  test "should update batch_beneficiary" do
    patch batch_beneficiary_url(@batch_beneficiary), params: { batch_beneficiary: { batch_id: @batch_beneficiary.batch_id, member_dependent_id: @batch_beneficiary.member_dependent_id } }
    assert_redirected_to batch_beneficiary_url(@batch_beneficiary)
  end

  test "should destroy batch_beneficiary" do
    assert_difference("BatchBeneficiary.count", -1) do
      delete batch_beneficiary_url(@batch_beneficiary)
    end

    assert_redirected_to batch_beneficiaries_url
  end
end
