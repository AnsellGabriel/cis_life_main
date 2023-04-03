require "application_system_test_case"

class BatchesTest < ApplicationSystemTestCase
  setup do
    @batch = batches(:one)
  end

  test "visiting the index" do
    visit batches_url
    assert_selector "h1", text: "Batches"
  end

  test "should create batch" do
    visit batches_url
    click_on "New batch"

    check "Active" if @batch.active
    fill_in "Agent sf amount", with: @batch.agent_sf_amount
    fill_in "Coop member", with: @batch.coop_member_id
    fill_in "Coop sf amount", with: @batch.coop_sf_amount
    fill_in "Effectivity date", with: @batch.effectivity_date
    fill_in "Expiry date", with: @batch.expiry_date
    fill_in "Group remit", with: @batch.group_remit_id
    click_on "Create Batch"

    assert_text "Batch was successfully created"
    click_on "Back"
  end

  test "should update Batch" do
    visit batch_url(@batch)
    click_on "Edit this batch", match: :first

    check "Active" if @batch.active
    fill_in "Agent sf amount", with: @batch.agent_sf_amount
    fill_in "Coop member", with: @batch.coop_member_id
    fill_in "Coop sf amount", with: @batch.coop_sf_amount
    fill_in "Effectivity date", with: @batch.effectivity_date
    fill_in "Expiry date", with: @batch.expiry_date
    fill_in "Group remit", with: @batch.group_remit_id
    click_on "Update Batch"

    assert_text "Batch was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch" do
    visit batch_url(@batch)
    click_on "Destroy this batch", match: :first

    assert_text "Batch was successfully destroyed"
  end
end
