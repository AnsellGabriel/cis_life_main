require "test_helper"

class ReinsurancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reinsurance = reinsurances(:one)
  end

  test "should get index" do
    get reinsurances_url
    assert_response :success
  end

  test "should get new" do
    get new_reinsurance_url
    assert_response :success
  end

  test "should create reinsurance" do
    assert_difference("Reinsurance.count") do
      post reinsurances_url, params: { reinsurance: { date_from: @reinsurance.date_from, date_to: @reinsurance.date_to, ri_total_amount: @reinsurance.ri_total_amount, ri_total_prem: @reinsurance.ri_total_prem } }
    end

    assert_redirected_to reinsurance_url(Reinsurance.last)
  end

  test "should show reinsurance" do
    get reinsurance_url(@reinsurance)
    assert_response :success
  end

  test "should get edit" do
    get edit_reinsurance_url(@reinsurance)
    assert_response :success
  end

  test "should update reinsurance" do
    patch reinsurance_url(@reinsurance), params: { reinsurance: { date_from: @reinsurance.date_from, date_to: @reinsurance.date_to, ri_total_amount: @reinsurance.ri_total_amount, ri_total_prem: @reinsurance.ri_total_prem } }
    assert_redirected_to reinsurance_url(@reinsurance)
  end

  test "should destroy reinsurance" do
    assert_difference("Reinsurance.count", -1) do
      delete reinsurance_url(@reinsurance)
    end

    assert_redirected_to reinsurances_url
  end
end
