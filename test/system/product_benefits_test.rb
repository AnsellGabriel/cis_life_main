require "application_system_test_case"

class ProductBenefitsTest < ApplicationSystemTestCase
  setup do
    @product_benefit = product_benefits(:one)
  end

  test "visiting the index" do
    visit product_benefits_url
    assert_selector "h1", text: "Product benefits"
  end

  test "should create product benefit" do
    visit product_benefits_url
    click_on "New product benefit"

    fill_in "Agreement benefit", with: @product_benefit.agreement_benefit_id
    fill_in "Coverage amount", with: @product_benefit.coverage_amount
    fill_in "Premium", with: @product_benefit.premium
    click_on "Create Product benefit"

    assert_text "Product benefit was successfully created"
    click_on "Back"
  end

  test "should update Product benefit" do
    visit product_benefit_url(@product_benefit)
    click_on "Edit this product benefit", match: :first

    fill_in "Agreement benefit", with: @product_benefit.agreement_benefit_id
    fill_in "Coverage amount", with: @product_benefit.coverage_amount
    fill_in "Premium", with: @product_benefit.premium
    click_on "Update Product benefit"

    assert_text "Product benefit was successfully updated"
    click_on "Back"
  end

  test "should destroy Product benefit" do
    visit product_benefit_url(@product_benefit)
    click_on "Destroy this product benefit", match: :first

    assert_text "Product benefit was successfully destroyed"
  end
end
