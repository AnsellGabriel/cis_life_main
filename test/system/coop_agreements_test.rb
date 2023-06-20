require "application_system_test_case"

class CoopAgreementsTest < ApplicationSystemTestCase
  setup do
    @coop_agreement = coop_agreements(:one)
  end

  test "visiting the index" do
    visit coop_agreements_url
    assert_selector "h1", text: "Coop agreements"
  end

  test "should create coop agreement" do
    visit coop_agreements_url
    click_on "New coop agreement"

    click_on "Create Coop agreement"

    assert_text "Coop agreement was successfully created"
    click_on "Back"
  end

  test "should update Coop agreement" do
    visit coop_agreement_url(@coop_agreement)
    click_on "Edit this coop agreement", match: :first

    click_on "Update Coop agreement"

    assert_text "Coop agreement was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop agreement" do
    visit coop_agreement_url(@coop_agreement)
    click_on "Destroy this coop agreement", match: :first

    assert_text "Coop agreement was successfully destroyed"
  end
end
