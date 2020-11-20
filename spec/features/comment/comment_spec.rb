require 'rails_helper'

describe 'User can add comment for the answer/question', "
  In order to add comment for the answer/question
  As an authenticated user
  I'd like to be able to add comment for the answer/question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated user' do
    it 'Unauthenticated can not add comment for question' do
      visit questions_path
      expect(page).not_to have_content 'Add comment'
    end

    it 'Unauthenticated can not add comment for answer' do
      visit question_path(question)
      expect(page).not_to have_content 'Add comment'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'can add comment for question', js: true do
      within '.new_question_comment' do
        fill_in 'Comment', with: 'comment'
        click_on 'Add comment'
      end

      within '.question-comments' do
        expect(page).to have_content 'comment'
      end
    end

    it "can't add invalid comment for question", js: true do
      within '.new_question_comment' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'
      end

      expect(page).to have_content "Body can't be blank"
    end

    it 'can add comment for answer', js: true do
      within '.answers' do
        fill_in 'Comment', with: 'comment'
        click_on 'Add comment'

        expect(page).to have_content 'comment'
      end
    end

    it "can't add invalid comment for answer", js: true do
      within '.answers' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'multiple sessions' do
    it "answer comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Comment', with: 'comment'
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

    it "question comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_question_comment' do
          fill_in 'Comment', with: 'comment'
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
