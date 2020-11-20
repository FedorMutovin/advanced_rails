require 'rails_helper'

describe 'User can show question with answers', "
 To find the answer i need
 As an authenticated or unauthenticated user
 I'd like to be able to view question with all answers
" do
  let(:user) { create :user }
  let!(:question) { create :question, author: user }

  it 'Authenticated user show a question with answers ' do
    sign_in(user)
    answers = create_list :answer, 2, question: question, author: user

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  it 'Unauthenticated user show a question with answers ' do
    answers = create_list :answer, 2, question: question, author: user

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
