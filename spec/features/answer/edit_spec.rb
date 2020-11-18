require 'rails_helper'

describe 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:other_answer) { create(:answer, question: question, author: other_user) }
  let(:url) { 'https://123/' }

  it 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    it 'edits his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    it 'edits his answer with errors', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end

      expect(page).to have_content "Body can't be blank"
    end

    it "tries to edit other user's question" do
      expect(page).not_to have_css("a[data-answer-id='#{other_answer.id}']")
    end

    it 'edits his answer with attached files', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    it 'edits his answer with links', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        fill_in 'Link name', with: 'My Gist'
        fill_in 'Url', with: url
        click_on 'Save'
      end

      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'My Gist', href: url
      end
    end
  end
end
