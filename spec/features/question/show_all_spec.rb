require 'rails_helper'

feature 'User can show all questions', %q{
 To find the question i need
 As an authenticated or unauthenticated user
 I'd like to be able to view all questions
} do
  given(:user) { create :user }

  scenario 'Authenticated user show a question' do
    sign_in(user)
    questions = create_list :question, 2, author: user
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
  scenario 'Unauthenticated user show a question' do
    questions = create_list :question, 2, author: user
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
