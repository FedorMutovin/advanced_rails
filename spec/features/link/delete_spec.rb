require 'rails_helper'

feature 'User can delete links', %q{
  If I need to delete my link
  As an authenticated user
  I'd like to be able to delete my link
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user ) }
  given!(:question_link) { create(:google_link, linkable: question) }
  given!(:answer_link) { create(:google_link, linkable: answer) }
  given(:other_user) { create(:user) }

  describe 'Author' do
    background { sign_in(user) }

    scenario 'delete question link', js:true do
      visit question_path(question)
      expect(page).to have_content question_link.name
      within '.question-links' do
        click_on 'Delete link'
        expect(page).not_to have_content question_link.name
      end
    end

    scenario 'delete answer link', js:true do
      visit question_path(question)
      expect(page).to have_content answer_link.name
      within '.answer-links' do
        click_on 'Delete link'
        expect(page).not_to have_content answer_link.name
      end
    end
  end

  describe 'Other user' do
    background { sign_in(other_user) }

    scenario 'delete question link', js:true do
      visit question_path(question)
      expect(page).to_not have_content 'Delete file'
    end

    scenario 'delete answer link', js:true do
      visit question_path(question)
      expect(page).to_not have_content 'Delete file'
    end
  end
end
