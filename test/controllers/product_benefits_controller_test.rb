require "test_helper"

class ProductBenefitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_benefit = product_benefits(:one)
  end

  test "should get index" do
    get product_benefits_url
    assert_response :success
  end

  test "should get new" do
    get new_product_benefit_url
    assert_response :success
  end

  test "should create product_benefit" do
    assert_difference("ProductBenefit.count") do
      post product_benefits_url, params: { product_benefit: { agreement_benefit_id: @product_benefit.agreement_benefit_id, coverage_amount: @product_benefit.coverage_amount, premium: @product_benefit.premium } }
    end

    assert_redirected_to product_benefit_url(ProductBenefit.last)
  end

  test "should show product_benefit" do
    get product_benefit_url(@product_benefit)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_benefit_url(@product_benefit)
    assert_response :success
  end

  test "should update product_benefit" do
    patch product_benefit_url(@product_benefit), params: { product_benefit: { agreement_benefit_id: @product_benefit.agreement_benefit_id, coverage_amount: @product_benefit.coverage_amount, premium: @product_benefit.premium } }
    assert_redirected_to product_benefit_url(@product_benefit)
  end

  test "should destroy product_benefit" do
    assert_difference("ProductBenefit.count", -1) do
      delete product_benefit_url(@product_benefit)
    end

    assert_redirected_to product_benefits_url
  end
end
