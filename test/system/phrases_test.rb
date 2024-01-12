require "application_system_test_case"

class PhrasesTest < ApplicationSystemTestCase
  setup do
    @phrase = phrases(:one)
  end

  test "visiting the index" do
    visit phrases_url
    assert_selector "h1", text: "Phrases"
  end

  test "should create phrase" do
    visit phrases_url
    click_on "New phrase"

    fill_in "Audio", with: @phrase.audio_id
    fill_in "Body", with: @phrase.body
    click_on "Create Phrase"

    assert_text "Phrase was successfully created"
    click_on "Back"
  end

  test "should update Phrase" do
    visit phrase_url(@phrase)
    click_on "Edit this phrase", match: :first

    fill_in "Audio", with: @phrase.audio_id
    fill_in "Body", with: @phrase.body
    click_on "Update Phrase"

    assert_text "Phrase was successfully updated"
    click_on "Back"
  end

  test "should destroy Phrase" do
    visit phrase_url(@phrase)
    click_on "Destroy this phrase", match: :first

    assert_text "Phrase was successfully destroyed"
  end
end
