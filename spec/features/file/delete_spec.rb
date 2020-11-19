require 'rails_helper'

describe 'User can delete files', "
  If I need to delete my file
  As an authenticated user
  I'd like to be able to delete my file
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:other_user) { create(:user) }

  describe 'Author' do
    before { sign_in(user) }

    it 'delete question file', js: true do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    it 'delete answer file', js: true do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      click_on 'Delete file'
      expect(page).not_to have_link 'spec_helper.rb'
    end
  end

  describe 'Other user' do
    before { sign_in(other_user) }

    it 'delete question file', js: true do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).not_to have_content 'Delete file'
    end

    it 'delete answer file', js: true do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).not_to have_content 'Delete file'
    end
  end
end
