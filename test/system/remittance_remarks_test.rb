require "application_system_test_case"

class RemittanceRemarksTest < ApplicationSystemTestCase
  setup do
    @remittance_remark = remittance_remarks(:one)
  end

  test "visiting the index" do
    visit remittance_remarks_url
    assert_selector "h1", text: "Remittance remarks"
  end

  test "should create remittance remark" do
    visit remittance_remarks_url
    click_on "New remittance remark"

    fill_in "Group remit", with: @remittance_remark.group_remit_id
    fill_in "Payment", with: @remittance_remark.payment_id
    fill_in "Remark", with: @remittance_remark.remark
    fill_in "Status", with: @remittance_remark.status
    click_on "Create Remittance remark"

    assert_text "Remittance remark was successfully created"
    click_on "Back"
  end

  test "should update Remittance remark" do
    visit remittance_remark_url(@remittance_remark)
    click_on "Edit this remittance remark", match: :first

    fill_in "Group remit", with: @remittance_remark.group_remit_id
    fill_in "Payment", with: @remittance_remark.payment_id
    fill_in "Remark", with: @remittance_remark.remark
    fill_in "Status", with: @remittance_remark.status
    click_on "Update Remittance remark"

    assert_text "Remittance remark was successfully updated"
    click_on "Back"
  end

  test "should destroy Remittance remark" do
    visit remittance_remark_url(@remittance_remark)
    click_on "Destroy this remittance remark", match: :first

    assert_text "Remittance remark was successfully destroyed"
  end
end
