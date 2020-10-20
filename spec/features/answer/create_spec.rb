require 'rails_helper'

feature 'User can create answer to the question', %q{
 If that's a question I can answer
 As an authenticated user
 I'd like to be to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'create answer' do
      fill_in 'Body', with: answer.body
      click_on 'Answer'
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content answer.body
    end

    scenario 'create wrong answer' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end
  scenario 'Unauthenticated user create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Answer'
  end
end
