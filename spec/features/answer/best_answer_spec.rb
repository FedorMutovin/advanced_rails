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
  given!(:other_question) { create(:question, author: other_user) }
  given!(:other_answer) { create(:answer, question: question, author: user) }
  given!(:reward) { create(:reward, question: question) }

  scenario 'Unauthenticated can not select best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user' do
    background { sign_in user }
    scenario 'select best answer', js:true do
      visit question_path(question)
      expect(page).to_not have_content 'This is best answer'

      find("a[href='#{mark_best_answer_path(answer)}']").click

      within '.answers' do
        expect(page).to have_content 'This is best answer'
        expect(page).to have_link reward.name
      end
    end

    scenario 'user select best answer for other user question' do
      visit question_path(other_question)
      expect(page).to_not have_link 'Best answer'
    end
  end
end
