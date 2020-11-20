require 'rails_helper'

describe 'User can delete answer', "
  If I need to delete my answer
  As an authenticated user
  I'd like to be able to delete my answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let(:other_user) { create(:user) }

  describe 'Authorized user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'delete answer', js: true do
      click_on 'Delete'
      expect(page).not_to have_content answer.body
    end

    it 'delete other user answer', js: true do
      other_answer = create(:answer, question: question, author: other_user)
      expect(page).not_to have_selector(:css, "a[href='#{answer_path(other_answer)}']")
    end
  end

  describe 'Unauthorized user' do
    it 'delete question' do
      visit questions_path
      expect(page).not_to have_content 'Delete'
    end
  end
end
