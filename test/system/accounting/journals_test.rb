require "application_system_test_case"

class Accounting::JournalsTest < ApplicationSystemTestCase
  setup do
    @accounting_journal = accounting_journals(:one)
  end

  test "visiting the index" do
    visit accounting_journals_url
    assert_selector "h1", text: "Journals"
  end

  test "should create journal" do
    visit accounting_journals_url
    click_on "New journal"

    click_on "Create Journal"

    assert_text "Journal was successfully created"
    click_on "Back"
  end

  test "should update Journal" do
    visit accounting_journal_url(@accounting_journal)
    click_on "Edit this journal", match: :first

    click_on "Update Journal"

    assert_text "Journal was successfully updated"
    click_on "Back"
  end

  test "should destroy Journal" do
    visit accounting_journal_url(@accounting_journal)
    click_on "Destroy this journal", match: :first

    assert_text "Journal was successfully destroyed"
  end
end
