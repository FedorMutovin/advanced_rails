require 'rails_helper'

describe 'User can subscribe to the new answers notification of question,', "
  In order to receive new answers to a question
  As an authenticated
  I'd like to be able to subscribe to the new answers notification of question
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let(:other_user) { create(:user) }

  describe 'Authenticated user' do
    it 'subscribe to the question', js: true do
      sign_in(other_user)
      visit questions_path
      within "#question-#{question.id}-subscribe-button" do
        expect(page).to have_button('Subscribe for new answers notifications')
        expect(page).not_to have_button('Disable notifications')
        click_on 'Subscribe for new answers notifications'
        expect(page).to have_button('Disable notifications')
        expect(page).not_to have_button('Subscribe for new answers notifications')
      end
    end

    it 'Unsubscribe to the question', js: true do
      sign_in(user)
      visit questions_path
      within "#question-#{question.id}-subscribe-button" do
        expect(page).not_to have_button('Subscribe for new answers notifications')
        expect(page).to have_button('Disable notifications')
        click_on 'Disable notifications'
        expect(page).to have_button('Subscribe for new answers notifications')
        expect(page).not_to have_button('Disable notifications')
      end
    end
  end

  describe 'Guest' do
    it 'try subscribe to the question' do
      visit question_path(question)
      expect(page).not_to have_button('Subscribe for new answers notifications')
    end
  end
end
