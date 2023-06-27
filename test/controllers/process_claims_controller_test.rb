require "test_helper"

class ProcessClaimsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @process_claim = process_claims(:one)
  end

  test "should get index" do
    get process_claims_url
    assert_response :success
  end

  test "should get new" do
    get new_process_claim_url
    assert_response :success
  end

  test "should create process_claim" do
    assert_difference("ProcessClaim.count") do
      post process_claims_url, params: { process_claim: { agreement_id: @process_claim.agreement_id, batch_id: @process_claim.batch_id, cooperative_id: @process_claim.cooperative_id, date_incident: @process_claim.date_incident, entry_type: @process_claim.entry_type } }
    end

    assert_redirected_to process_claim_url(ProcessClaim.last)
  end

  test "should show process_claim" do
    get process_claim_url(@process_claim)
    assert_response :success
  end

  test "should get edit" do
    get edit_process_claim_url(@process_claim)
    assert_response :success
  end

  test "should update process_claim" do
    patch process_claim_url(@process_claim), params: { process_claim: { agreement_id: @process_claim.agreement_id, batch_id: @process_claim.batch_id, cooperative_id: @process_claim.cooperative_id, date_incident: @process_claim.date_incident, entry_type: @process_claim.entry_type } }
    assert_redirected_to process_claim_url(@process_claim)
  end

  test "should destroy process_claim" do
    assert_difference("ProcessClaim.count", -1) do
      delete process_claim_url(@process_claim)
    end

    assert_redirected_to process_claims_url
  end
end
