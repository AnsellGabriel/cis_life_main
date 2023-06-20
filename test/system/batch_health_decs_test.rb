require "application_system_test_case"

class BatchHealthDecsTest < ApplicationSystemTestCase
  setup do
    @batch_health_dec = batch_health_decs(:one)
  end

  test "visiting the index" do
    visit batch_health_decs_url
    assert_selector "h1", text: "Batch health decs"
  end

  test "should create batch health dec" do
    visit batch_health_decs_url
    click_on "New batch health dec"

    check "Ans q1" if @batch_health_dec.ans_q1
    check "Ans q2" if @batch_health_dec.ans_q2
    check "Ans q3" if @batch_health_dec.ans_q3
    fill_in "Ans q3 desc", with: @batch_health_dec.ans_q3_desc
    check "Ans q4" if @batch_health_dec.ans_q4
    fill_in "Ans q4 desc", with: @batch_health_dec.ans_q4_desc
    check "Ans q5 a" if @batch_health_dec.ans_q5_a
    fill_in "Ans q5 a desc", with: @batch_health_dec.ans_q5_a_desc
    check "Ans q5 b" if @batch_health_dec.ans_q5_b
    fill_in "Batch", with: @batch_health_dec.batch_id
    click_on "Create Batch health dec"

    assert_text "Batch health dec was successfully created"
    click_on "Back"
  end

  test "should update Batch health dec" do
    visit batch_health_dec_url(@batch_health_dec)
    click_on "Edit this batch health dec", match: :first

    check "Ans q1" if @batch_health_dec.ans_q1
    check "Ans q2" if @batch_health_dec.ans_q2
    check "Ans q3" if @batch_health_dec.ans_q3
    fill_in "Ans q3 desc", with: @batch_health_dec.ans_q3_desc
    check "Ans q4" if @batch_health_dec.ans_q4
    fill_in "Ans q4 desc", with: @batch_health_dec.ans_q4_desc
    check "Ans q5 a" if @batch_health_dec.ans_q5_a
    fill_in "Ans q5 a desc", with: @batch_health_dec.ans_q5_a_desc
    check "Ans q5 b" if @batch_health_dec.ans_q5_b
    fill_in "Batch", with: @batch_health_dec.batch_id
    click_on "Update Batch health dec"

    assert_text "Batch health dec was successfully updated"
    click_on "Back"
  end

  test "should destroy Batch health dec" do
    visit batch_health_dec_url(@batch_health_dec)
    click_on "Destroy this batch health dec", match: :first

    assert_text "Batch health dec was successfully destroyed"
  end
end
