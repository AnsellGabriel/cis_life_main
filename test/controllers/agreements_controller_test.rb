require "test_helper"

class AgreementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agreement = agreements(:one)
  end

  test "should get index" do
    get agreements_url
    assert_response :success
  end

  test "should get new" do
    get new_agreement_url
    assert_response :success
  end

  test "should create agreement" do
    assert_difference("Agreement.count") do
      post agreements_url, params: { agreement: { agent_id: @agreement.agent_id, anniversary_type: @agreement.anniversary_type, claims_fund: @agreement.claims_fund, comm_type: @agreement.comm_type, contestability: @agreement.contestability, cooperative_id: @agreement.cooperative_id, entry_age_from: @agreement.entry_age_from, entry_age_to: @agreement.entry_age_to, exit_age: @agreement.exit_age, moa_no: @agreement.moa_no, nel: @agreement.nel, nml: @agreement.nml, plan_id: @agreement.plan_id, previous_provider: @agreement.previous_provider, transferred: @agreement.transferred, transferred_date: @agreement.transferred_date } }
    end

    assert_redirected_to agreement_url(Agreement.last)
  end

  test "should show agreement" do
    get agreement_url(@agreement)
    assert_response :success
  end

  test "should get edit" do
    get edit_agreement_url(@agreement)
    assert_response :success
  end

  test "should update agreement" do
    patch agreement_url(@agreement), params: { agreement: { agent_id: @agreement.agent_id, anniversary_type: @agreement.anniversary_type, claims_fund: @agreement.claims_fund, comm_type: @agreement.comm_type, contestability: @agreement.contestability, cooperative_id: @agreement.cooperative_id, entry_age_from: @agreement.entry_age_from, entry_age_to: @agreement.entry_age_to, exit_age: @agreement.exit_age, moa_no: @agreement.moa_no, nel: @agreement.nel, nml: @agreement.nml, plan_id: @agreement.plan_id, previous_provider: @agreement.previous_provider, transferred: @agreement.transferred, transferred_date: @agreement.transferred_date } }
    assert_redirected_to agreement_url(@agreement)
  end

  test "should destroy agreement" do
    assert_difference("Agreement.count", -1) do
      delete agreement_url(@agreement)
    end

    assert_redirected_to agreements_url
  end
end
