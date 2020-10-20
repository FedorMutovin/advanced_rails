require 'rails_helper'

feature 'User can delete question', %q{
 If I need to delete my question
 As an authenticated user
 I'd like to be able to delete my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, author: other_user) }

  describe 'Authorized user' do
    background { sign_in(user) }

    scenario 'delete question' do
      visit questions_path
      click_on 'Delete'
      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario 'delete other user question' do
      expect(page).to_not have_selector(:css, "a[href='#{question_path(other_question)}']")
    end
  end

  describe 'Unauthorized user' do
    scenario 'delete question' do
      visit questions_path
      expect(page).to_not have_content 'Delete'
    end
  end
end
