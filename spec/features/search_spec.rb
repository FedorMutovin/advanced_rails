require 'sphinx_helper'

describe 'User can search', "
  In order to search some information
  As an unauthenticated or authenticate user
  I'd like to be able to use search
" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:comment) { create(:comment, commentable: answer, user: user) }

  it 'search in Questions', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      fill_in 'search_text', with: question.title
      select 'Questions', from: 'search_object'
      click_on 'Search'

      within '.search_results_block' do
        expect(page).to have_content question.title
      end
    end
  end

  it 'search in Answers', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      fill_in 'search_text', with: answer.body
      select 'Answers', from: 'search_object'
      click_on 'Search'

      within '.search_results_block' do
        expect(page).to have_content answer.body
      end
    end
  end

  it 'search in Comments', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      fill_in 'search_text', with: comment.body
      select 'Comments', from: 'search_object'
      click_on 'Search'

      within '.search_results_block' do
        expect(page).to have_content comment.body
      end
    end
  end

  it 'search in Users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      fill_in 'search_text', with: user.email
      select 'Users', from: 'search_object'
      click_on 'Search'

      within '.search_results_block' do
        expect(page).to have_content user.email
      end
    end
  end

  it 'search in all', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      fill_in 'search_text', with: question.title
      select 'All', from: 'search_object'
      click_on 'Search'

      within('.search_results_block') do
        expect(page).to have_content(question.title)
      end
    end
  end
end
