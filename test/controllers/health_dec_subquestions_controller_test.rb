require "test_helper"

class HealthDecSubquestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @health_dec_subquestion = health_dec_subquestions(:one)
  end

  test "should get index" do
    get health_dec_subquestions_url
    assert_response :success
  end

  test "should get new" do
    get new_health_dec_subquestion_url
    assert_response :success
  end

  test "should create health_dec_subquestion" do
    assert_difference("HealthDecSubquestion.count") do
      post health_dec_subquestions_url, params: { health_dec_subquestion: {  } }
    end

    assert_redirected_to health_dec_subquestion_url(HealthDecSubquestion.last)
  end

  test "should show health_dec_subquestion" do
    get health_dec_subquestion_url(@health_dec_subquestion)
    assert_response :success
  end

  test "should get edit" do
    get edit_health_dec_subquestion_url(@health_dec_subquestion)
    assert_response :success
  end

  test "should update health_dec_subquestion" do
    patch health_dec_subquestion_url(@health_dec_subquestion), params: { health_dec_subquestion: {  } }
    assert_redirected_to health_dec_subquestion_url(@health_dec_subquestion)
  end

  test "should destroy health_dec_subquestion" do
    assert_difference("HealthDecSubquestion.count", -1) do
      delete health_dec_subquestion_url(@health_dec_subquestion)
    end

    assert_redirected_to health_dec_subquestions_url
  end
end
