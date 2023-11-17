require "test_helper"

class HealthDecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @health_dec = health_decs(:one)
  end

  test "should get index" do
    get health_decs_url
    assert_response :success
  end

  test "should get new" do
    get new_health_dec_url
    assert_response :success
  end

  test "should create health_dec" do
    assert_difference("HealthDec.count") do
      post health_decs_url,
params: { health_dec: { active: @health_dec.active, question: @health_dec.question, question_sort: @health_dec.question_sort, valid_answer: @health_dec.valid_answer,
with_details: @health_dec.with_details } }
    end

    assert_redirected_to health_dec_url(HealthDec.last)
  end

  test "should show health_dec" do
    get health_dec_url(@health_dec)
    assert_response :success
  end

  test "should get edit" do
    get edit_health_dec_url(@health_dec)
    assert_response :success
  end

  test "should update health_dec" do
    patch health_dec_url(@health_dec),
params: { health_dec: { active: @health_dec.active, question: @health_dec.question, question_sort: @health_dec.question_sort, valid_answer: @health_dec.valid_answer,
with_details: @health_dec.with_details } }
    assert_redirected_to health_dec_url(@health_dec)
  end

  test "should destroy health_dec" do
    assert_difference("HealthDec.count", -1) do
      delete health_dec_url(@health_dec)
    end

    assert_redirected_to health_decs_url
  end
end
