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

    click_on "Create Cooperative"

    assert_text "Cooperative was successfully created"
    click_on "Back"
  end

  test "should update Cooperative" do
    visit cooperative_url(@cooperative)
    click_on "Edit this cooperative", match: :first

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
