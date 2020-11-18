require 'rails_helper'

describe 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:url) { 'https://123/' }
  let!(:gist_link) { create(:gist_link, linkable: question) }

  before do
    sign_in(user)
  end

  it 'User adds link when asks question' do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: url
  end

  it 'User adds some links when asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: url

    click_on 'add Links'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Double Gist'
      fill_in 'Url', with: url
    end

    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: url
    expect(page).to have_link 'Double Gist', href: url
  end

  it 'User adds invalid url' do
    visit new_question_path

    fill_in 'Url', with: 'abc'
    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end

  it 'can see gist content', js: true do
    visit question_path(question)

    expect(page).to have_content gist_link.gist
  end
end
