require 'rails_helper'

describe 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:other_question) { create(:question, author: other_user) }
  let(:url) { 'https://123/' }

  it 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit questions_path
    end

    it 'edits his question', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: 'edited title'
        fill_in 'Question body', with: 'edited body'
        click_on 'Save'

        expect(page).not_to have_content question.body
        expect(page).not_to have_content question.title
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'edits his question with errors', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
      end

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
    end

    it "tries to edit other user's question" do
      expect(page).not_to have_css("a[data-question-id='#{other_question.id}']")
    end

    it 'edits his question with attached files', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: 'edited title'
        fill_in 'Question body', with: 'edited body'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'edits his question with links', js: true do
      click_on 'Edit'

      within '.questions' do
        fill_in 'Question title', with: 'edited title'
        fill_in 'Question body', with: 'edited body'

        fill_in 'Link name', with: 'My Gist'
        fill_in 'Url', with: url
        click_on 'Save'
      end

      visit question_path(question)

      expect(page).to have_link 'My Gist', href: url
    end
  end
end
