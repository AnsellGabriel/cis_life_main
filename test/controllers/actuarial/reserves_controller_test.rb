require "test_helper"

class Actuarial::ReservesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actuarial_reserf = actuarial_reserves(:one)
  end

  test "should get index" do
    get actuarial_reserves_url
    assert_response :success
  end

  test "should get new" do
    get new_actuarial_reserf_url
    assert_response :success
  end

  test "should create actuarial_reserf" do
    assert_difference("Actuarial::Reserve.count") do
      post actuarial_reserves_url, params: { actuarial_reserf: { first_term: @actuarial_reserf.first_term, plan_id: @actuarial_reserf.plan_id, second_term: @actuarial_reserf.second_term, third_term: @actuarial_reserf.third_term, total_first_advance_pr: @actuarial_reserf.total_first_advance_pr, total_first_advance_prem: @actuarial_reserf.total_first_advance_prem, total_reserve: @actuarial_reserf.total_reserve, total_reserve_ret: @actuarial_reserf.total_reserve_ret, total_second_advance_pr: @actuarial_reserf.total_second_advance_pr, total_second_advance_prem: @actuarial_reserf.total_second_advance_prem, total_unearned_pr: @actuarial_reserf.total_unearned_pr, total_unearned_prem: @actuarial_reserf.total_unearned_prem } }
    end

    assert_redirected_to actuarial_reserf_url(Actuarial::Reserve.last)
  end

  test "should show actuarial_reserf" do
    get actuarial_reserf_url(@actuarial_reserf)
    assert_response :success
  end

  test "should get edit" do
    get edit_actuarial_reserf_url(@actuarial_reserf)
    assert_response :success
  end

  test "should update actuarial_reserf" do
    patch actuarial_reserf_url(@actuarial_reserf), params: { actuarial_reserf: { first_term: @actuarial_reserf.first_term, plan_id: @actuarial_reserf.plan_id, second_term: @actuarial_reserf.second_term, third_term: @actuarial_reserf.third_term, total_first_advance_pr: @actuarial_reserf.total_first_advance_pr, total_first_advance_prem: @actuarial_reserf.total_first_advance_prem, total_reserve: @actuarial_reserf.total_reserve, total_reserve_ret: @actuarial_reserf.total_reserve_ret, total_second_advance_pr: @actuarial_reserf.total_second_advance_pr, total_second_advance_prem: @actuarial_reserf.total_second_advance_prem, total_unearned_pr: @actuarial_reserf.total_unearned_pr, total_unearned_prem: @actuarial_reserf.total_unearned_prem } }
    assert_redirected_to actuarial_reserf_url(@actuarial_reserf)
  end

  test "should destroy actuarial_reserf" do
    assert_difference("Actuarial::Reserve.count", -1) do
      delete actuarial_reserf_url(@actuarial_reserf)
    end

    assert_redirected_to actuarial_reserves_url
  end
end
