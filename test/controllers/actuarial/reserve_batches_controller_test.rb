require "test_helper"

class Actuarial::ReserveBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actuarial_reserve_batch = actuarial_reserve_batches(:one)
  end

  test "should get index" do
    get actuarial_reserve_batches_url
    assert_response :success
  end

  test "should get new" do
    get new_actuarial_reserve_batch_url
    assert_response :success
  end

  test "should create actuarial_reserve_batch" do
    assert_difference("Actuarial::ReserveBatch.count") do
      post actuarial_reserve_batches_url, params: { actuarial_reserve_batch: { actuarial_reserve_id: @actuarial_reserve_batch.actuarial_reserve_id, batch_id: @actuarial_reserve_batch.batch_id, cov_less_ret: @actuarial_reserve_batch.cov_less_ret, coverage_less_ri: @actuarial_reserve_batch.coverage_less_ri, duration: @actuarial_reserve_batch.duration, first_adv_pr: @actuarial_reserve_batch.first_adv_pr, first_adv_prem: @actuarial_reserve_batch.first_adv_prem, first_term: @actuarial_reserve_batch.first_term, prem_less_ret: @actuarial_reserve_batch.prem_less_ret, prem_less_ri: @actuarial_reserve_batch.prem_less_ri, rate: @actuarial_reserve_batch.rate, reserve: @actuarial_reserve_batch.reserve, reserve_ret: @actuarial_reserve_batch.reserve_ret, second_adv_pr: @actuarial_reserve_batch.second_adv_pr, second_adv_prem: @actuarial_reserve_batch.second_adv_prem, second_term: @actuarial_reserve_batch.second_term, term: @actuarial_reserve_batch.term, third_term: @actuarial_reserve_batch.third_term, unearned_pr: @actuarial_reserve_batch.unearned_pr, unearned_prem: @actuarial_reserve_batch.unearned_prem } }
    end

    assert_redirected_to actuarial_reserve_batch_url(Actuarial::ReserveBatch.last)
  end

  test "should show actuarial_reserve_batch" do
    get actuarial_reserve_batch_url(@actuarial_reserve_batch)
    assert_response :success
  end

  test "should get edit" do
    get edit_actuarial_reserve_batch_url(@actuarial_reserve_batch)
    assert_response :success
  end

  test "should update actuarial_reserve_batch" do
    patch actuarial_reserve_batch_url(@actuarial_reserve_batch), params: { actuarial_reserve_batch: { actuarial_reserve_id: @actuarial_reserve_batch.actuarial_reserve_id, batch_id: @actuarial_reserve_batch.batch_id, cov_less_ret: @actuarial_reserve_batch.cov_less_ret, coverage_less_ri: @actuarial_reserve_batch.coverage_less_ri, duration: @actuarial_reserve_batch.duration, first_adv_pr: @actuarial_reserve_batch.first_adv_pr, first_adv_prem: @actuarial_reserve_batch.first_adv_prem, first_term: @actuarial_reserve_batch.first_term, prem_less_ret: @actuarial_reserve_batch.prem_less_ret, prem_less_ri: @actuarial_reserve_batch.prem_less_ri, rate: @actuarial_reserve_batch.rate, reserve: @actuarial_reserve_batch.reserve, reserve_ret: @actuarial_reserve_batch.reserve_ret, second_adv_pr: @actuarial_reserve_batch.second_adv_pr, second_adv_prem: @actuarial_reserve_batch.second_adv_prem, second_term: @actuarial_reserve_batch.second_term, term: @actuarial_reserve_batch.term, third_term: @actuarial_reserve_batch.third_term, unearned_pr: @actuarial_reserve_batch.unearned_pr, unearned_prem: @actuarial_reserve_batch.unearned_prem } }
    assert_redirected_to actuarial_reserve_batch_url(@actuarial_reserve_batch)
  end

  test "should destroy actuarial_reserve_batch" do
    assert_difference("Actuarial::ReserveBatch.count", -1) do
      delete actuarial_reserve_batch_url(@actuarial_reserve_batch)
    end

    assert_redirected_to actuarial_reserve_batches_url
  end
end
