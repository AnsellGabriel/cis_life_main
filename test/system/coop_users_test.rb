require "application_system_test_case"

class CoopUsersTest < ApplicationSystemTestCase
  setup do
    @coop_user = coop_users(:one)
  end

  test "visiting the index" do
    visit coop_users_url
    assert_selector "h1", text: "Coop users"
  end

  test "should create coop user" do
    visit coop_users_url
    click_on "New coop user"

    click_on "Create Coop user"

    assert_text "Coop user was successfully created"
    click_on "Back"
  end

  test "should update Coop user" do
    visit coop_user_url(@coop_user)
    click_on "Edit this coop user", match: :first

    click_on "Update Coop user"

    assert_text "Coop user was successfully updated"
    click_on "Back"
  end

  test "should destroy Coop user" do
    visit coop_user_url(@coop_user)
    click_on "Destroy this coop user", match: :first

    assert_text "Coop user was successfully destroyed"
  end
end
