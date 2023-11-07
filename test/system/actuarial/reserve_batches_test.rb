require "application_system_test_case"

class Actuarial::ReserveBatchesTest < ApplicationSystemTestCase
  setup do
    @actuarial_reserve_batch = actuarial_reserve_batches(:one)
  end

  test "visiting the index" do
    visit actuarial_reserve_batches_url
    assert_selector "h1", text: "Reserve batches"
  end

  test "should create reserve batch" do
    visit actuarial_reserve_batches_url
    click_on "New reserve batch"

    fill_in "Actuarial reserve", with: @actuarial_reserve_batch.actuarial_reserve_id
    fill_in "Batch", with: @actuarial_reserve_batch.batch_id
    fill_in "Cov less ret", with: @actuarial_reserve_batch.cov_less_ret
    fill_in "Coverage less ri", with: @actuarial_reserve_batch.coverage_less_ri
    fill_in "Duration", with: @actuarial_reserve_batch.duration
    fill_in "First adv pr", with: @actuarial_reserve_batch.first_adv_pr
    fill_in "First adv prem", with: @actuarial_reserve_batch.first_adv_prem
    fill_in "First term", with: @actuarial_reserve_batch.first_term
    fill_in "Prem less ret", with: @actuarial_reserve_batch.prem_less_ret
    fill_in "Prem less ri", with: @actuarial_reserve_batch.prem_less_ri
    fill_in "Rate", with: @actuarial_reserve_batch.rate
    fill_in "Reserve", with: @actuarial_reserve_batch.reserve
    fill_in "Reserve ret", with: @actuarial_reserve_batch.reserve_ret
    fill_in "Second adv pr", with: @actuarial_reserve_batch.second_adv_pr
    fill_in "Second adv prem", with: @actuarial_reserve_batch.second_adv_prem
    fill_in "Second term", with: @actuarial_reserve_batch.second_term
    fill_in "Term", with: @actuarial_reserve_batch.term
    fill_in "Third term", with: @actuarial_reserve_batch.third_term
    fill_in "Unearned pr", with: @actuarial_reserve_batch.unearned_pr
    fill_in "Unearned prem", with: @actuarial_reserve_batch.unearned_prem
    click_on "Create Reserve batch"

    assert_text "Reserve batch was successfully created"
    click_on "Back"
  end

  test "should update Reserve batch" do
    visit actuarial_reserve_batch_url(@actuarial_reserve_batch)
    click_on "Edit this reserve batch", match: :first

    fill_in "Actuarial reserve", with: @actuarial_reserve_batch.actuarial_reserve_id
    fill_in "Batch", with: @actuarial_reserve_batch.batch_id
    fill_in "Cov less ret", with: @actuarial_reserve_batch.cov_less_ret
    fill_in "Coverage less ri", with: @actuarial_reserve_batch.coverage_less_ri
    fill_in "Duration", with: @actuarial_reserve_batch.duration
    fill_in "First adv pr", with: @actuarial_reserve_batch.first_adv_pr
    fill_in "First adv prem", with: @actuarial_reserve_batch.first_adv_prem
    fill_in "First term", with: @actuarial_reserve_batch.first_term
    fill_in "Prem less ret", with: @actuarial_reserve_batch.prem_less_ret
    fill_in "Prem less ri", with: @actuarial_reserve_batch.prem_less_ri
    fill_in "Rate", with: @actuarial_reserve_batch.rate
    fill_in "Reserve", with: @actuarial_reserve_batch.reserve
    fill_in "Reserve ret", with: @actuarial_reserve_batch.reserve_ret
    fill_in "Second adv pr", with: @actuarial_reserve_batch.second_adv_pr
    fill_in "Second adv prem", with: @actuarial_reserve_batch.second_adv_prem
    fill_in "Second term", with: @actuarial_reserve_batch.second_term
    fill_in "Term", with: @actuarial_reserve_batch.term
    fill_in "Third term", with: @actuarial_reserve_batch.third_term
    fill_in "Unearned pr", with: @actuarial_reserve_batch.unearned_pr
    fill_in "Unearned prem", with: @actuarial_reserve_batch.unearned_prem
    click_on "Update Reserve batch"

    assert_text "Reserve batch was successfully updated"
    click_on "Back"
  end

  test "should destroy Reserve batch" do
    visit actuarial_reserve_batch_url(@actuarial_reserve_batch)
    click_on "Destroy this reserve batch", match: :first

    assert_text "Reserve batch was successfully destroyed"
  end
end
