require 'rails_helper'

describe 'User can select best answer for his question', "
 If that's a best answer for my question
 As an authenticated user
 I'd like to be to select best answer for my question
" do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:other_question) { create(:question, author: other_user) }
  let!(:other_answer) { create(:answer, question: question, author: user) }
  let!(:reward) { create(:reward, question: question) }

  it 'Unauthenticated can not select best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Best answer'
  end

  describe 'Authenticated user' do
    before { sign_in user }

    it 'select best answer', js: true do
      visit question_path(question)
      expect(page).not_to have_content 'This is best answer'

      find("a[href='#{mark_best_answer_path(answer)}']").click

      within '.answers' do
        expect(page).to have_content 'This is best answer'
        expect(page).to have_link reward.name
      end
    end

    it 'user select best answer for other user question' do
      visit question_path(other_question)
      expect(page).not_to have_link 'Best answer'
    end
  end
end
