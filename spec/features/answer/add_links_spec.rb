require 'rails_helper'

describe 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let!(:gist_link) { create(:gist_link, linkable: answer) }
  let(:url) { 'https://123/' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User' do
    it 'adds link when give an answer', js: true do
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: url

      click_on 'Answer'

      expect(page).to have_link 'My Gist', href: url
    end

    it 'adds invalid url', js: true do
      fill_in 'Url', with: 'abc'
      click_on 'Answer'

      expect(page).to have_content 'Links url is not a valid URL'
    end

    it 'can see gist content', js: true do
      within '.answers' do
        expect(page).to have_content gist_link.gist
      end
    end
  end
end
