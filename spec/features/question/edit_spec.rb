require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:other_question) { create(:question, author: other_user) }

  scenario 'Unauthenticated can not edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit questions_path
    end

    scenario 'edits his answer', js:true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: 'edited title'
        fill_in 'Question body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js:true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
      end

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"

    end

    scenario "tries to edit other user's question" do
      expect(page).to_not have_css("a[data-question-id='#{other_question.id}']")
    end
  end

end