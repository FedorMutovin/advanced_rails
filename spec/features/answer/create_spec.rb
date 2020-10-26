require 'rails_helper'

feature 'User can create answer to the question', %q{
 If that's a question I can answer
 As an authenticated user
 I'd like to be to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'create answer', js:true do
      fill_in 'Body', with: answer.body
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'create wrong answer', js:true do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create a answer with attached files', js:true do
      fill_in 'Body', with: answer.body

      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
  scenario 'Unauthenticated user create answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Body'
    expect(page).to_not have_content 'Answer'
  end
end
