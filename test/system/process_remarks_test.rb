require "application_system_test_case"

class ProcessRemarksTest < ApplicationSystemTestCase
  setup do
    @process_remark = process_remarks(:one)
  end

  test "visiting the index" do
    visit process_remarks_url
    assert_selector "h1", text: "Process remarks"
  end

  test "should create process remark" do
    visit process_remarks_url
    click_on "New process remark"

    fill_in "Process coverage", with: @process_remark.process_coverage_id
    fill_in "Remark", with: @process_remark.remark
    fill_in "Status", with: @process_remark.status
    fill_in "User", with: @process_remark.user_id
    fill_in "User type", with: @process_remark.user_type
    click_on "Create Process remark"

    assert_text "Process remark was successfully created"
    click_on "Back"
  end

  test "should update Process remark" do
    visit process_remark_url(@process_remark)
    click_on "Edit this process remark", match: :first

    fill_in "Process coverage", with: @process_remark.process_coverage_id
    fill_in "Remark", with: @process_remark.remark
    fill_in "Status", with: @process_remark.status
    fill_in "User", with: @process_remark.user_id
    fill_in "User type", with: @process_remark.user_type
    click_on "Update Process remark"

    assert_text "Process remark was successfully updated"
    click_on "Back"
  end

  test "should destroy Process remark" do
    visit process_remark_url(@process_remark)
    click_on "Destroy this process remark", match: :first

    assert_text "Process remark was successfully destroyed"
  end
end
