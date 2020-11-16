require 'rails_helper'

feature 'User can add comment for the answer/question', %q{
  In order to add comment for the answer/question
  As an authenticated user
  I'd like to be able to add comment for the answer/question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated can not add comment for question' do
      visit questions_path
      expect(page).to_not have_content 'Add comment'
    end

    scenario 'Unauthenticated can not add comment for answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Add comment'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can add comment for question', js:true do
      within '.new_question_comment' do
        fill_in 'Comment', with: "comment"
        click_on 'Add comment'
      end

      within '.question-comments' do
        expect(page).to have_content 'comment'
      end
    end

    scenario "can't add invalid comment for question", js:true do
      within '.new_question_comment' do
        fill_in 'Comment', with: ""
        click_on 'Add comment'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can add comment for answer', js:true do
      within '.answers' do
        fill_in 'Comment', with: "comment"
        click_on 'Add comment'

        expect(page).to have_content 'comment'
      end
    end

    scenario "can't add invalid comment for answer", js:true do
      within '.answers' do
        fill_in 'Comment', with: ""
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context "multiple sessions" do
    scenario "answer comment appears on another user's page", js:true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Comment', with: "comment"
          click_on 'Add comment'

          expect(page).to have_content 'comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'comment'
        end
      end
    end

    scenario "question comment appears on another user's page", js:true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_question_comment' do
          fill_in 'Comment', with: "comment"
          click_on 'Add comment'
        end

        within '.question-comments' do
          expect(page).to have_content 'comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'comment'
        end
      end
    end
  end
end
