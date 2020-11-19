require 'rails_helper'

describe 'User can sign up', "
 To start ask questions and give answers
 As an authenticated user
 I'd like to be able to sign up
" do
  before { visit new_user_registration_path }

  it 'User tries to sign up' do
    fill_in 'Email', with: 'user@user.user'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    open_email('user@user.user')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  it 'User tries to sign up with invalid fills' do
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end
end
