require 'rails_helper'

feature 'User can subscribe to the new answers notification of question,', "
  In order to receive new answers to a question
  As an authenticated
  I'd like to be able to subscribe to the new answers notification of question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:other_question) { create(:question, author: other_user) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'subscribe to the question', js: true do
      sign_in(other_user)
      visit questions_path
      save_and_open_page
      within "#question-#{question.id}-subscribe-button" do
        expect(page).to have_button("Subscribe for new answers notifications")
        expect(page).to_not have_button('Disable notifications')
        click_on 'Subscribe for new answers notifications'
        expect(page).to have_button('Disable notifications')
        expect(page).to_not have_button("Subscribe for new answers notifications")
      end
    end

    scenario 'Unsubscribe to the question', js: true do
      sign_in(user)
      visit questions_path
      within "#question-#{question.id}-subscribe-button" do
        expect(page).to_not have_button("Subscribe for new answers notifications")
        expect(page).to have_button('Disable notifications')
        click_on 'Disable notifications'
        expect(page).to have_button("Subscribe for new answers notifications")
        expect(page).to_not have_button('Disable notifications')
      end
    end
  end

  describe 'Guest' do
    it 'try subscribe to the question' do
      visit question_path(question)
      expect(page).to_not have_button("Subscribe for new answers notifications")
    end
  end
end
