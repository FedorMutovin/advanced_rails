require 'rails_helper'

describe 'User can delete question', "
 If I need to delete my question
 As an authenticated user
 I'd like to be able to delete my question
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, author: other_user) }

  describe 'Authorized user' do
    before { sign_in(user) }

    it 'delete question' do
      visit questions_path
      click_on 'Delete'
      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).not_to have_content question.title
    end

    it 'delete other user question' do
      expect(page).not_to have_selector(:css, "a[href='#{question_path(other_question)}']")
    end
  end

  describe 'Unauthorized user' do
    it 'delete question' do
      visit questions_path
      expect(page).not_to have_content 'Delete'
    end
  end
end
