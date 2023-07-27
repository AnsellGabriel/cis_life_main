require "application_system_test_case"

class DeniedDependentsTest < ApplicationSystemTestCase
  setup do
    @denied_dependent = denied_dependents(:one)
  end

  test "visiting the index" do
    visit denied_dependents_url
    assert_selector "h1", text: "Denied dependents"
  end

  test "should create denied dependent" do
    visit denied_dependents_url
    click_on "New denied dependent"

    fill_in "Age", with: @denied_dependent.age
    fill_in "Group remit", with: @denied_dependent.group_remit_id
    fill_in "Name", with: @denied_dependent.name
    fill_in "Reason", with: @denied_dependent.reason
    click_on "Create Denied dependent"

    assert_text "Denied dependent was successfully created"
    click_on "Back"
  end

  test "should update Denied dependent" do
    visit denied_dependent_url(@denied_dependent)
    click_on "Edit this denied dependent", match: :first

    fill_in "Age", with: @denied_dependent.age
    fill_in "Group remit", with: @denied_dependent.group_remit_id
    fill_in "Name", with: @denied_dependent.name
    fill_in "Reason", with: @denied_dependent.reason
    click_on "Update Denied dependent"

    assert_text "Denied dependent was successfully updated"
    click_on "Back"
  end

  test "should destroy Denied dependent" do
    visit denied_dependent_url(@denied_dependent)
    click_on "Destroy this denied dependent", match: :first

    assert_text "Denied dependent was successfully destroyed"
  end
end
