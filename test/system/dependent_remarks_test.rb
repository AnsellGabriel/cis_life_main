require "application_system_test_case"

class DependentRemarksTest < ApplicationSystemTestCase
  setup do
    @dependent_remark = dependent_remarks(:one)
  end

  test "visiting the index" do
    visit dependent_remarks_url
    assert_selector "h1", text: "Dependent remarks"
  end

  test "should create dependent remark" do
    visit dependent_remarks_url
    click_on "New dependent remark"

    fill_in "Batch dependent", with: @dependent_remark.batch_dependent_id
    fill_in "Remark", with: @dependent_remark.remark
    fill_in "Status", with: @dependent_remark.status
    click_on "Create Dependent remark"

    assert_text "Dependent remark was successfully created"
    click_on "Back"
  end

  test "should update Dependent remark" do
    visit dependent_remark_url(@dependent_remark)
    click_on "Edit this dependent remark", match: :first

    fill_in "Batch dependent", with: @dependent_remark.batch_dependent_id
    fill_in "Remark", with: @dependent_remark.remark
    fill_in "Status", with: @dependent_remark.status
    click_on "Update Dependent remark"

    assert_text "Dependent remark was successfully updated"
    click_on "Back"
  end

  test "should destroy Dependent remark" do
    visit dependent_remark_url(@dependent_remark)
    click_on "Destroy this dependent remark", match: :first

    assert_text "Dependent remark was successfully destroyed"
  end
end
