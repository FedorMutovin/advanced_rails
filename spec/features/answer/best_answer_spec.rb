require 'rails_helper'

feature 'User can select best answer for his question', %q{
 If that's a best answer for my question
 As an authenticated user
 I'd like to be to select best answer for my question
} do

  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_answer) { create(:answer, question: question, author: other_user) }

  scenario 'Unauthenticated can not select best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'select best answer', js:true do
      click_on 'Best answer'

      within '.answers' do
        expect(page).to have_content 'This is best answer'
      end
    end

    scenario 'user select best answer for other user question' do
      expect(page).to_not have_selector(:css, "a[href='#{mark_best_answer_path(other_answer)}']")
    end
  end
end
