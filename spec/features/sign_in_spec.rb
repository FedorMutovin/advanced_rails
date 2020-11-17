require 'rails_helper'

feature 'User can sign in', %q{
 In order to ask questions
 As an unauthenticated user
 I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'Sign in with ouath services', js: true do

    scenario 'Github' do
      mock_auth_hash_github
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'Facebook' do
      mock_auth_hash_facebook
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end

end
