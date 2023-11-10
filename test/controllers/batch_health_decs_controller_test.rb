require "test_helper"

class BatchHealthDecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @batch_health_dec = batch_health_decs(:one)
  end

  test "should get index" do
    get batch_health_decs_url
    assert_response :success
  end

  test "should get new" do
    get new_batch_health_dec_url
    assert_response :success
  end

  test "should create batch_health_dec" do
    assert_difference("BatchHealthDec.count") do
      post batch_health_decs_url,
params: { batch_health_dec: { ans_q1: @batch_health_dec.ans_q1, ans_q2: @batch_health_dec.ans_q2, ans_q3: @batch_health_dec.ans_q3, ans_q3_desc: @batch_health_dec.ans_q3_desc,
ans_q4: @batch_health_dec.ans_q4, ans_q4_desc: @batch_health_dec.ans_q4_desc, ans_q5_a: @batch_health_dec.ans_q5_a, ans_q5_a_desc: @batch_health_dec.ans_q5_a_desc, ans_q5_b: @batch_health_dec.ans_q5_b, batch_id: @batch_health_dec.batch_id } }
    end

    assert_redirected_to batch_health_dec_url(BatchHealthDec.last)
  end

  test "should show batch_health_dec" do
    get batch_health_dec_url(@batch_health_dec)
    assert_response :success
  end

  test "should get edit" do
    get edit_batch_health_dec_url(@batch_health_dec)
    assert_response :success
  end

  test "should update batch_health_dec" do
    patch batch_health_dec_url(@batch_health_dec),
params: { batch_health_dec: { ans_q1: @batch_health_dec.ans_q1, ans_q2: @batch_health_dec.ans_q2, ans_q3: @batch_health_dec.ans_q3, ans_q3_desc: @batch_health_dec.ans_q3_desc,
ans_q4: @batch_health_dec.ans_q4, ans_q4_desc: @batch_health_dec.ans_q4_desc, ans_q5_a: @batch_health_dec.ans_q5_a, ans_q5_a_desc: @batch_health_dec.ans_q5_a_desc, ans_q5_b: @batch_health_dec.ans_q5_b, batch_id: @batch_health_dec.batch_id } }
    assert_redirected_to batch_health_dec_url(@batch_health_dec)
  end

  test "should destroy batch_health_dec" do
    assert_difference("BatchHealthDec.count", -1) do
      delete batch_health_dec_url(@batch_health_dec)
    end

    assert_redirected_to batch_health_decs_url
  end
end
