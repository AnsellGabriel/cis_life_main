require "test_helper"

class Accounting::JournalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @accounting_journal = accounting_journals(:one)
  end

  test "should get index" do
    get accounting_journals_url
    assert_response :success
  end

  test "should get new" do
    get new_accounting_journal_url
    assert_response :success
  end

  test "should create accounting_journal" do
    assert_difference("Accounting::Journal.count") do
      post accounting_journals_url, params: { accounting_journal: {  } }
    end

    assert_redirected_to accounting_journal_url(Accounting::Journal.last)
  end

  test "should show accounting_journal" do
    get accounting_journal_url(@accounting_journal)
    assert_response :success
  end

  test "should get edit" do
    get edit_accounting_journal_url(@accounting_journal)
    assert_response :success
  end

  test "should update accounting_journal" do
    patch accounting_journal_url(@accounting_journal), params: { accounting_journal: {  } }
    assert_redirected_to accounting_journal_url(@accounting_journal)
  end

  test "should destroy accounting_journal" do
    assert_difference("Accounting::Journal.count", -1) do
      delete accounting_journal_url(@accounting_journal)
    end

    assert_redirected_to accounting_journals_url
  end
end
