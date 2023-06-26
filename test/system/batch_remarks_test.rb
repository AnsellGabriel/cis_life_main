require "application_system_test_case"

class BatchRemarksTest < ApplicationSystemTestCase
  setup do
    @batch_remark = batch_remarks(:one)
  end

  test "visiting the index" do
    visit batch_remarks_url
    assert_selector "h1", text: "Batch remarks"
  end

  test "should create batch remark" do
    visit batch_remarks_url
    click_on "New batch remark"

    fill_in "Batch", with: @batch_remark.batch_id
    fill_in "Remark", with: @batch_remark.remark
    fill_in "User", with: @batch_remark.user_id
    fill_in "User type", with: @batch_remark.user_type
    click_on "Create Batch remark"

    assert_text "Batch remark was successfully created"
    click_on "Back"
  end

  test "should update Batch remark" do
    visit batch_remark_url(@batch_remark)
    click_on "Edit this batch remark", match: :first

    fill_in "Batch", with: @batch_remark.batch_id
    fill_in "Remark", with: @batch_remark.remark
    fill_in "User", with: @batch_remark.user_id
    fill_in "User type", with: @batch_remark.user_type
    click_on "Update Batch remark"

    assert_text "Batch remark was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch remark" do
    visit batch_remark_url(@batch_remark)
    click_on "Destroy this batch remark", match: :first

    assert_text "Batch remark was successfully destroyed"
  end
end
