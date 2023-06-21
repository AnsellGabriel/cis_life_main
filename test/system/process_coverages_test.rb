require "application_system_test_case"

class ProcessCoveragesTest < ApplicationSystemTestCase
  setup do
    @process_coverage = process_coverages(:one)
  end

  test "visiting the index" do
    visit process_coverages_url
    assert_selector "h1", text: "Process coverages"
  end

  test "should create process coverage" do
    visit process_coverages_url
    click_on "New process coverage"

    fill_in "Agent", with: @process_coverage.agent_id
    fill_in "Approved count", with: @process_coverage.approved_count
    fill_in "Approved total coverage", with: @process_coverage.approved_total_coverage
    fill_in "Approved total prem", with: @process_coverage.approved_total_prem
    fill_in "Denied count", with: @process_coverage.denied_count
    fill_in "Denied total coverage", with: @process_coverage.denied_total_coverage
    fill_in "Denied total prem", with: @process_coverage.denied_total_prem
    fill_in "Effectivity", with: @process_coverage.effectivity
    fill_in "Expiry", with: @process_coverage.expiry
    fill_in "Group remit", with: @process_coverage.group_remit_id
    fill_in "Status", with: @process_coverage.status
    click_on "Create Process coverage"

    assert_text "Process coverage was successfully created"
    click_on "Back"
  end

  test "should update Process coverage" do
    visit process_coverage_url(@process_coverage)
    click_on "Edit this process coverage", match: :first

    fill_in "Agent", with: @process_coverage.agent_id
    fill_in "Approved count", with: @process_coverage.approved_count
    fill_in "Approved total coverage", with: @process_coverage.approved_total_coverage
    fill_in "Approved total prem", with: @process_coverage.approved_total_prem
    fill_in "Denied count", with: @process_coverage.denied_count
    fill_in "Denied total coverage", with: @process_coverage.denied_total_coverage
    fill_in "Denied total prem", with: @process_coverage.denied_total_prem
    fill_in "Effectivity", with: @process_coverage.effectivity
    fill_in "Expiry", with: @process_coverage.expiry
    fill_in "Group remit", with: @process_coverage.group_remit_id
    fill_in "Status", with: @process_coverage.status
    click_on "Update Process coverage"

    assert_text "Process coverage was successfully updated"
    click_on "Back"
  end

  test "should destroy Process coverage" do
    visit process_coverage_url(@process_coverage)
    click_on "Destroy this process coverage", match: :first

    assert_text "Process coverage was successfully destroyed"
  end
end
