require "application_system_test_case"

class CooperativesTest < ApplicationSystemTestCase
  setup do
    @cooperative = cooperatives(:one)
  end

  test "visiting the index" do
    visit cooperatives_url
    assert_selector "h1", text: "Cooperatives"
  end

  test "should create cooperative" do
    visit cooperatives_url
    click_on "New cooperative"

    fill_in "Barangay", with: @cooperative.barangay
    fill_in "Contact details", with: @cooperative.contact_details
    fill_in "Municipality", with: @cooperative.municipality
    fill_in "Name", with: @cooperative.name
    fill_in "Province", with: @cooperative.province
    fill_in "Region", with: @cooperative.region
    click_on "Create Cooperative"

    assert_text "Cooperative was successfully created"
    click_on "Back"
  end

  test "should update Cooperative" do
    visit cooperative_url(@cooperative)
    click_on "Edit this cooperative", match: :first

    fill_in "Barangay", with: @cooperative.barangay
    fill_in "Contact details", with: @cooperative.contact_details
    fill_in "Municipality", with: @cooperative.municipality
    fill_in "Name", with: @cooperative.name
    fill_in "Province", with: @cooperative.province
    fill_in "Region", with: @cooperative.region
    click_on "Update Cooperative"

    assert_text "Cooperative was successfully updated"
    click_on "Back"
  end

  test "should destroy Cooperative" do
    visit cooperative_url(@cooperative)
    click_on "Destroy this cooperative", match: :first

    assert_text "Cooperative was successfully destroyed"
  end
end
