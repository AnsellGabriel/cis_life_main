require "test_helper"

class AgentGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent_group = agent_groups(:one)
  end

  test "should get index" do
    get agent_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_agent_group_url
    assert_response :success
  end

  test "should create agent_group" do
    assert_difference("AgentGroup.count") do
      post agent_groups_url, params: { agent_group: {  } }
    end

    assert_redirected_to agent_group_url(AgentGroup.last)
  end

  test "should show agent_group" do
    get agent_group_url(@agent_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_agent_group_url(@agent_group)
    assert_response :success
  end

  test "should update agent_group" do
    patch agent_group_url(@agent_group), params: { agent_group: {  } }
    assert_redirected_to agent_group_url(@agent_group)
  end

  test "should destroy agent_group" do
    assert_difference("AgentGroup.count", -1) do
      delete agent_group_url(@agent_group)
    end

    assert_redirected_to agent_groups_url
  end
end
