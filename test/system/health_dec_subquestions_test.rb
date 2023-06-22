require "application_system_test_case"

class HealthDecSubquestionsTest < ApplicationSystemTestCase
  setup do
    @health_dec_subquestion = health_dec_subquestions(:one)
  end

  test "visiting the index" do
    visit health_dec_subquestions_url
    assert_selector "h1", text: "Health dec subquestions"
  end

  test "should create health dec subquestion" do
    visit health_dec_subquestions_url
    click_on "New health dec subquestion"

    click_on "Create Health dec subquestion"

    assert_text "Health dec subquestion was successfully created"
    click_on "Back"
  end

  test "should update Health dec subquestion" do
    visit health_dec_subquestion_url(@health_dec_subquestion)
    click_on "Edit this health dec subquestion", match: :first

    click_on "Update Health dec subquestion"

    assert_text "Health dec subquestion was successfully updated"
    click_on "Back"
  end

  test "should destroy Health dec subquestion" do
    visit health_dec_subquestion_url(@health_dec_subquestion)
    click_on "Destroy this health dec subquestion", match: :first

    assert_text "Health dec subquestion was successfully destroyed"
  end
end
