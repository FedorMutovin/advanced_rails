require 'rails_helper'

feature 'User can delete answer', %q{
  If I need to delete my answer
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user ) }
  given(:other_user) { create(:user) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'delete answer' do
      click_on 'Delete'
      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'delete other user answer' do
      other_answer = create(:answer, question: question, author: other_user)
      expect(page).to_not have_selector(:css, "a[href='#{answer_path(other_answer)}']")
    end
  end

  describe 'Unauthorized user' do
    scenario 'delete question' do
      visit questions_path
      expect(page).to_not have_content 'Delete'
    end
  end
end
