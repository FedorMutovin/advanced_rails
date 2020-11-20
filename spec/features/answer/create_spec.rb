require 'rails_helper'

describe 'User can create answer to the question', "
 If that's a question I can answer
 As an authenticated user
 I'd like to be to answer the question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'create answer', js: true do
      fill_in 'Body', with: answer.body
      click_on 'Answer'

      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.answers' do
        expect(page).to have_content answer.body
      end
    end

    it 'create wrong answer', js: true do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    it 'create a answer with attached files', js: true do
      fill_in 'Body', with: answer.body

      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  it 'Unauthenticated user create answer' do
    visit question_path(question)
    expect(page).not_to have_content 'Body'
    expect(page).not_to have_content 'Answer'
  end

  context 'multiple sessions' do
    it "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text text'
        click_on 'Answer'

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end
end
