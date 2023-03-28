require "test_helper"

class CoopBranchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coop_branch = coop_branches(:one)
  end

  test "should get index" do
    get coop_branches_url
    assert_response :success
  end

  test "should get new" do
    get new_coop_branch_url
    assert_response :success
  end

  test "should create coop_branch" do
    assert_difference("CoopBranch.count") do
      post coop_branches_url, params: { coop_branch: { barangay: @coop_branch.barangay, contact_details: @coop_branch.contact_details, cooperative_id: @coop_branch.cooperative_id, municipality: @coop_branch.municipality, name: @coop_branch.name, province: @coop_branch.province, region: @coop_branch.region } }
    end

    assert_redirected_to coop_branch_url(CoopBranch.last)
  end

  test "should show coop_branch" do
    get coop_branch_url(@coop_branch)
    assert_response :success
  end

  test "should get edit" do
    get edit_coop_branch_url(@coop_branch)
    assert_response :success
  end

  test "should update coop_branch" do
    patch coop_branch_url(@coop_branch), params: { coop_branch: { barangay: @coop_branch.barangay, contact_details: @coop_branch.contact_details, cooperative_id: @coop_branch.cooperative_id, municipality: @coop_branch.municipality, name: @coop_branch.name, province: @coop_branch.province, region: @coop_branch.region } }
    assert_redirected_to coop_branch_url(@coop_branch)
  end

  test "should destroy coop_branch" do
    assert_difference("CoopBranch.count", -1) do
      delete coop_branch_url(@coop_branch)
    end

    assert_redirected_to coop_branches_url
  end
end
