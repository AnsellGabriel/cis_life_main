require "application_system_test_case"

class GroupRemitsTest < ApplicationSystemTestCase
  setup do
    @group_remit = group_remits(:one)
  end

  test "visiting the index" do
    visit group_remits_url
    assert_selector "h1", text: "Group remits"
  end

  test "should create group remit" do
    visit group_remits_url
    click_on "New group remit"

    fill_in "Agreement", with: @group_remit.agreement_id
    fill_in "Anniversary", with: @group_remit.anniversary_id
    fill_in "Description", with: @group_remit.description
    fill_in "Name", with: @group_remit.name
    click_on "Create Group remit"

    assert_text "Group remit was successfully created"
    click_on "Back"
  end

  test "should update Group remit" do
    visit group_remit_url(@group_remit)
    click_on "Edit this group remit", match: :first

    fill_in "Agreement", with: @group_remit.agreement_id
    fill_in "Anniversary", with: @group_remit.anniversary_id
    fill_in "Description", with: @group_remit.description
    fill_in "Name", with: @group_remit.name
    click_on "Update Group remit"

    assert_text "Group remit was successfully updated"
    click_on "Back"
  end

  test "should destroy Group remit" do
    visit group_remit_url(@group_remit)
    click_on "Destroy this group remit", match: :first

    assert_text "Group remit was successfully destroyed"
  end
end
