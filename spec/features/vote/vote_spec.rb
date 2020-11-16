require 'rails_helper'

feature 'User can vote for the correct answer/question', %q{
  In order to mark the correct answer/questi
  As an authenticated user
  I'd like to be able to vote for the correct answer/question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated can not vote for question' do
      visit questions_path
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end

    scenario 'Unauthenticated can not vote for answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(other_user)
    end

    scenario 'can vote for question', js:true do
      click_on 'Vote for'

      expect(page).to have_content '1'
    end

    scenario 'can vote against question', js:true do
      click_on 'Vote against'

      expect(page).to have_content '-1'
    end

    scenario "can't vote twice", js:true do
      click_on 'Vote for'

      expect(page).to_not have_content "Vote for"
      expect(page).to_not have_content "Vote against"
    end

    scenario "can re-vote", js:true do
      click_on 'Vote for'
      click_on 'Delete my vote'
      click_on 'Vote against'

      expect(page).to have_content "-1"
    end
  end

  describe 'Author of resource' do
    background do
      sign_in(user)
    end

    scenario "can't vote for his question" do
      visit questions_path
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end

    scenario "can't vote for his answer" do
      visit question_path(question)
      expect(page).to_not have_content 'Vote for'
      expect(page).to_not have_content 'Vote against'
    end
  end
end
