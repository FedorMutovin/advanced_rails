
require 'rails_helper'

feature 'User can show question with answers', %q{
 To find the answer i need
 As an authenticated or unauthenticated user
 I'd like to be able to view question with all answers
} do
  given(:user) { create :user }
  given!(:question) { create :question, author: user }

  scenario 'Authenticated user show a question with answers ' do
    sign_in(user)
    answers = create_list :answer, 2, question: question, author: user

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user show a question with answers ' do
    answers = create_list :answer, 2, question: question, author: user

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
