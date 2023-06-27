require "test_helper"

class ProcessCoveragesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @process_coverage = process_coverages(:one)
  end

  test "should get index" do
    get process_coverages_url
    assert_response :success
  end

  test "should get new" do
    get new_process_coverage_url
    assert_response :success
  end

  test "should create process_coverage" do
    assert_difference("ProcessCoverage.count") do
      post process_coverages_url, params: { process_coverage: { agent_id: @process_coverage.agent_id, approved_count: @process_coverage.approved_count, approved_total_coverage: @process_coverage.approved_total_coverage, approved_total_prem: @process_coverage.approved_total_prem, denied_count: @process_coverage.denied_count, denied_total_coverage: @process_coverage.denied_total_coverage, denied_total_prem: @process_coverage.denied_total_prem, effectivity: @process_coverage.effectivity, expiry: @process_coverage.expiry, group_remit_id: @process_coverage.group_remit_id, status: @process_coverage.status } }
    end

    assert_redirected_to process_coverage_url(ProcessCoverage.last)
  end

  test "should show process_coverage" do
    get process_coverage_url(@process_coverage)
    assert_response :success
  end

  test "should get edit" do
    get edit_process_coverage_url(@process_coverage)
    assert_response :success
  end

  test "should update process_coverage" do
    patch process_coverage_url(@process_coverage), params: { process_coverage: { agent_id: @process_coverage.agent_id, approved_count: @process_coverage.approved_count, approved_total_coverage: @process_coverage.approved_total_coverage, approved_total_prem: @process_coverage.approved_total_prem, denied_count: @process_coverage.denied_count, denied_total_coverage: @process_coverage.denied_total_coverage, denied_total_prem: @process_coverage.denied_total_prem, effectivity: @process_coverage.effectivity, expiry: @process_coverage.expiry, group_remit_id: @process_coverage.group_remit_id, status: @process_coverage.status } }
    assert_redirected_to process_coverage_url(@process_coverage)
  end

  test "should destroy process_coverage" do
    assert_difference("ProcessCoverage.count", -1) do
      delete process_coverage_url(@process_coverage)
    end

    assert_redirected_to process_coverages_url
  end
end
