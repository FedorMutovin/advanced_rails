require 'rails_helper'

describe 'User can delete links', "
  If I need to delete my link
  As an authenticated user
  I'd like to be able to delete my link
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:question_link) { create(:google_link, linkable: question) }
  let!(:answer_link) { create(:google_link, linkable: answer) }
  let(:other_user) { create(:user) }

  describe 'Author' do
    before { sign_in(user) }

    it 'delete question link', js: true do
      visit question_path(question)
      expect(page).to have_content question_link.name
      within '.question-links' do
        click_on 'Delete link'
        expect(page).not_to have_content question_link.name
      end
    end

    it 'delete answer link', js: true do
      visit question_path(question)
      expect(page).to have_content answer_link.name
      within '.answer-links' do
        click_on 'Delete link'
        expect(page).not_to have_content answer_link.name
      end
    end
  end

  describe 'Other user' do
    before { sign_in(other_user) }

    it 'delete question link', js: true do
      visit question_path(question)
      expect(page).not_to have_content 'Delete file'
    end

    it 'delete answer link', js: true do
      visit question_path(question)
      expect(page).not_to have_content 'Delete file'
    end
  end
end
