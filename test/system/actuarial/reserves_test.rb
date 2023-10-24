require "application_system_test_case"

class Actuarial::ReservesTest < ApplicationSystemTestCase
  setup do
    @actuarial_reserf = actuarial_reserves(:one)
  end

  test "visiting the index" do
    visit actuarial_reserves_url
    assert_selector "h1", text: "Reserves"
  end

  test "should create reserve" do
    visit actuarial_reserves_url
    click_on "New reserve"

    fill_in "First term", with: @actuarial_reserf.first_term
    fill_in "Plan", with: @actuarial_reserf.plan_id
    fill_in "Second term", with: @actuarial_reserf.second_term
    fill_in "Third term", with: @actuarial_reserf.third_term
    fill_in "Total first advance pr", with: @actuarial_reserf.total_first_advance_pr
    fill_in "Total first advance prem", with: @actuarial_reserf.total_first_advance_prem
    fill_in "Total reserve", with: @actuarial_reserf.total_reserve
    fill_in "Total reserve ret", with: @actuarial_reserf.total_reserve_ret
    fill_in "Total second advance pr", with: @actuarial_reserf.total_second_advance_pr
    fill_in "Total second advance prem", with: @actuarial_reserf.total_second_advance_prem
    fill_in "Total unearned pr", with: @actuarial_reserf.total_unearned_pr
    fill_in "Total unearned prem", with: @actuarial_reserf.total_unearned_prem
    click_on "Create Reserve"

    assert_text "Reserve was successfully created"
    click_on "Back"
  end

  test "should update Reserve" do
    visit actuarial_reserf_url(@actuarial_reserf)
    click_on "Edit this reserve", match: :first

    fill_in "First term", with: @actuarial_reserf.first_term
    fill_in "Plan", with: @actuarial_reserf.plan_id
    fill_in "Second term", with: @actuarial_reserf.second_term
    fill_in "Third term", with: @actuarial_reserf.third_term
    fill_in "Total first advance pr", with: @actuarial_reserf.total_first_advance_pr
    fill_in "Total first advance prem", with: @actuarial_reserf.total_first_advance_prem
    fill_in "Total reserve", with: @actuarial_reserf.total_reserve
    fill_in "Total reserve ret", with: @actuarial_reserf.total_reserve_ret
    fill_in "Total second advance pr", with: @actuarial_reserf.total_second_advance_pr
    fill_in "Total second advance prem", with: @actuarial_reserf.total_second_advance_prem
    fill_in "Total unearned pr", with: @actuarial_reserf.total_unearned_pr
    fill_in "Total unearned prem", with: @actuarial_reserf.total_unearned_prem
    click_on "Update Reserve"

    assert_text "Reserve was successfully updated"
    click_on "Back"
  end

  test "should destroy Reserve" do
    visit actuarial_reserf_url(@actuarial_reserf)
    click_on "Destroy this reserve", match: :first

    assert_text "Reserve was successfully destroyed"
  end
end
