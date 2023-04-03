require "test_helper"

class AgreementBenefitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agreement_benefit = agreement_benefits(:one)
  end

  test "should get index" do
    get agreement_benefits_url
    assert_response :success
  end

  test "should get new" do
    get new_agreement_benefit_url
    assert_response :success
  end

  test "should create agreement_benefit" do
    assert_difference("AgreementBenefit.count") do
      post agreement_benefits_url, params: { agreement_benefit: { description: @agreement_benefit.description, name: @agreement_benefit.name } }
    end

    assert_redirected_to agreement_benefit_url(AgreementBenefit.last)
  end

  test "should show agreement_benefit" do
    get agreement_benefit_url(@agreement_benefit)
    assert_response :success
  end

  test "should get edit" do
    get edit_agreement_benefit_url(@agreement_benefit)
    assert_response :success
  end

  test "should update agreement_benefit" do
    patch agreement_benefit_url(@agreement_benefit), params: { agreement_benefit: { description: @agreement_benefit.description, name: @agreement_benefit.name } }
    assert_redirected_to agreement_benefit_url(@agreement_benefit)
  end

  test "should destroy agreement_benefit" do
    assert_difference("AgreementBenefit.count", -1) do
      delete agreement_benefit_url(@agreement_benefit)
    end

    assert_redirected_to agreement_benefits_url
  end
end
