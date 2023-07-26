require "application_system_test_case"

class UserLevelsTest < ApplicationSystemTestCase
  setup do
    @user_level = user_levels(:one)
  end

  test "visiting the index" do
    visit user_levels_url
    assert_selector "h1", text: "User levels"
  end

  test "should create user level" do
    visit user_levels_url
    click_on "New user level"

    check "Active" if @user_level.active
    fill_in "Authority level", with: @user_level.authority_level_id
    fill_in "User", with: @user_level.user_id
    click_on "Create User level"

    assert_text "User level was successfully created"
    click_on "Back"
  end

  test "should update User level" do
    visit user_level_url(@user_level)
    click_on "Edit this user level", match: :first

    check "Active" if @user_level.active
    fill_in "Authority level", with: @user_level.authority_level_id
    fill_in "User", with: @user_level.user_id
    click_on "Update User level"

    assert_text "User level was successfully updated"
    click_on "Back"
  end

  test "should destroy User level" do
    visit user_level_url(@user_level)
    click_on "Destroy this user level", match: :first

    assert_text "User level was successfully destroyed"
  end
end
