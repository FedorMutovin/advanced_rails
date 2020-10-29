require 'rails_helper'

feature 'User can delete files', %q{
  If I need to delete my file
  As an authenticated user
  I'd like to be able to delete my file
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user ) }
  given(:other_user) { create(:user) }

  describe 'Author' do
    background { sign_in(user) }

    scenario 'delete question file', js:true do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario 'delete answer file', js:true do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end
  end

  describe 'Other user' do
    background { sign_in(other_user) }

    scenario 'delete question file', js:true do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).to_not have_content 'Delete file'
    end

    scenario 'delete answer file', js:true do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).to_not have_content 'Delete file'
    end
  end
end
