require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/FedorMutovin/00719ddb7e67687c023d8352d36d5ce3' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: gist_url
  end

  scenario 'User adds dome links when asks question', js:true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: gist_url

    click_on 'add Links'

    within all(".nested-fields")[1] do
      fill_in 'Link name', with: 'Double Gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My Gist', href: gist_url
    expect(page).to have_link 'Double Gist', href: gist_url
  end

end
