require 'rails_helper'

describe 'User can show all questions', "
 To find the question i need
 As an authenticated or unauthenticated user
 I'd like to be able to view all questions
" do
  let(:user) { create :user }

  describe 'Authenticated user' do
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, best: true, question: question, author: user }

    it 'show a questions' do
      sign_in(user)
      questions = create_list :question, 2, author: user
      visit questions_path

      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end

  it 'Unauthenticated user show a question' do
    questions = create_list :question, 2, author: user
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
