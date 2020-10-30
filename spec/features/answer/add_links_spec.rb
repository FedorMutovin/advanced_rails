require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/FedorMutovin/00719ddb7e67687c023d8352d36d5ce3' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My Gist', href: gist_url
    end
  end

  scenario 'User adds invalid url', js: true do
    fill_in 'Url', with: 'abc'
    click_on 'Answer'

    expect(page).to have_content 'Links url is not a valid URL'
  end
end
