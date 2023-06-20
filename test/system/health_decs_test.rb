require "application_system_test_case"

class HealthDecsTest < ApplicationSystemTestCase
  setup do
    @health_dec = health_decs(:one)
  end

  test "visiting the index" do
    visit health_decs_url
    assert_selector "h1", text: "Health decs"
  end

  test "should create health dec" do
    visit health_decs_url
    click_on "New health dec"

    check "Active" if @health_dec.active
    fill_in "Question", with: @health_dec.question
    fill_in "Question sort", with: @health_dec.question_sort
    check "Valid answer" if @health_dec.valid_answer
    check "With details" if @health_dec.with_details
    click_on "Create Health dec"

    assert_text "Health dec was successfully created"
    click_on "Back"
  end

  test "should update Health dec" do
    visit health_dec_url(@health_dec)
    click_on "Edit this health dec", match: :first

    check "Active" if @health_dec.active
    fill_in "Question", with: @health_dec.question
    fill_in "Question sort", with: @health_dec.question_sort
    check "Valid answer" if @health_dec.valid_answer
    check "With details" if @health_dec.with_details
    click_on "Update Health dec"

    assert_text "Health dec was successfully updated"
    click_on "Back"
  end

  test "should destroy Health dec" do
    visit health_dec_url(@health_dec)
    click_on "Destroy this health dec", match: :first

    assert_text "Health dec was successfully destroyed"
  end
end
