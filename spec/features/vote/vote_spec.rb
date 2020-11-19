require 'rails_helper'

describe 'User can vote for the correct answer/question', "
  In order to mark the correct answer/questi
  As an authenticated user
  I'd like to be able to vote for the correct answer/question
" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated user' do
    it 'Unauthenticated can not vote for question' do
      visit questions_path
      expect(page).not_to have_content 'Vote for'
      expect(page).not_to have_content 'Vote against'
    end

    it 'Unauthenticated can not vote for answer' do
      visit question_path(question)
      expect(page).not_to have_content 'Vote for'
      expect(page).not_to have_content 'Vote against'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(other_user)
    end

    it 'can vote for question', js: true do
      click_on 'Vote for'

      expect(page).to have_content '1'
    end

    it 'can vote against question', js: true do
      click_on 'Vote against'

      expect(page).to have_content '-1'
    end

    it "can't vote twice", js: true do
      click_on 'Vote for'

      expect(page).not_to have_content 'Vote for'
      expect(page).not_to have_content 'Vote against'
    end

    it 'can re-vote', js: true do
      click_on 'Vote for'
      click_on 'Delete my vote'
      click_on 'Vote against'

      expect(page).to have_content '-1'
    end
  end

  describe 'Author of resource' do
    before do
      sign_in(user)
    end

    it "can't vote for his question" do
      visit questions_path
      expect(page).not_to have_content 'Vote for'
      expect(page).not_to have_content 'Vote against'
    end

    it "can't vote for his answer" do
      visit question_path(question)
      expect(page).not_to have_content 'Vote for'
      expect(page).not_to have_content 'Vote against'
    end
  end
end
