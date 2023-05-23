require "application_system_test_case"

class AgentGroupsTest < ApplicationSystemTestCase
  setup do
    @agent_group = agent_groups(:one)
  end

  test "visiting the index" do
    visit agent_groups_url
    assert_selector "h1", text: "Agent groups"
  end

  test "should create agent group" do
    visit agent_groups_url
    click_on "New agent group"

    click_on "Create Agent group"

    assert_text "Agent group was successfully created"
    click_on "Back"
  end

  test "should update Agent group" do
    visit agent_group_url(@agent_group)
    click_on "Edit this agent group", match: :first

    click_on "Update Agent group"

    assert_text "Agent group was successfully updated"
    click_on "Back"
  end

  test "should destroy Agent group" do
    visit agent_group_url(@agent_group)
    click_on "Destroy this agent group", match: :first

    assert_text "Agent group was successfully destroyed"
  end
end
