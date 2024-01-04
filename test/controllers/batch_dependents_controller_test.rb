require "test_helper"

class BatchDependentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch_dependent = batch_dependents(:one)
  end

  test "should get index" do
    get batch_dependents_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_dependent_url
    assert_response :success
  end

  test "should create batch_dependent" do
    assert_difference("BatchDependent.count") do
      post batch_dependents_url,
params: { batch_dependent: { agreement_benefit_id: @batch_dependent.agreement_benefit_id, batch_id: @batch_dependent.batch_id, coop_dependent_id: @batch_dependent.coop_dependent_id,
premium: @batch_dependent.premium } }
    end

    assert_redirected_to batch_dependent_url(BatchDependent.last)
  end

  test "should show batch_dependent" do
    get batch_dependent_url(@batch_dependent)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_dependent_url(@batch_dependent)
    assert_response :success
  end

  test "should update batch_dependent" do
    patch batch_dependent_url(@batch_dependent),
params: { batch_dependent: { agreement_benefit_id: @batch_dependent.agreement_benefit_id, batch_id: @batch_dependent.batch_id, coop_dependent_id: @batch_dependent.coop_dependent_id,
premium: @batch_dependent.premium } }
    assert_redirected_to batch_dependent_url(@batch_dependent)
  end

  test "should destroy batch_dependent" do
    assert_difference("BatchDependent.count", -1) do
      delete batch_dependent_url(@batch_dependent)
    end

    assert_redirected_to batch_dependents_url
  end
end
