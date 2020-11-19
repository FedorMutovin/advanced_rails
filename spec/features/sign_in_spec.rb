require 'rails_helper'

describe 'User can sign in', "
 In order to ask questions
 As an unauthenticated user
 I'd like to be able to sign in
" do
  let(:user) { create(:user) }

  before { visit new_user_session_path }

  it 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  it 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'Sign in with ouath services', js: true do
    %w[GitHub Facebook].each do |network|
      before do
        clean_mock_auth(network)
      end

      describe 'Registered user' do
        it 'try to sign in' do
          mock_auth_hash(network.downcase, email: 'test@mail.ru')
          click_on "Sign in with #{network}"
          expect(page).to have_content "Successfully authenticated from #{network.capitalize} account."
        end

        it 'try to sign in with failure' do
          failure_mock_auth(network.downcase)
          click_on "Sign in with #{network}"
          expect(page).to have_content "Could not authenticate you from #{network} because \"Invalid credentials\"."
        end
      end

      describe 'Unregistered user' do
        context "#{network} return email" do
          it 'try to sign in' do
            mock_auth_hash(network.downcase, email: 'test@mail.ru')
            click_on "Sign in with #{network}"
            expect(page).to have_content "Successfully authenticated from #{network.capitalize} account."
          end
        end

        context "#{network} not return email" do
          it 'user type email yourself' do
            mock_auth_hash(network.downcase, email: nil)
            click_on "Sign in with #{network}"
            expect(page).to have_content 'Email'
            fill_in 'Email', with: 'new@mail.com'
            click_on 'Add email'
            expect(page).to have_content 'You need to confirm your email'
          end

          it 'user try type exist email' do
            mock_auth_hash(network.downcase, email: nil)
            click_on "Sign in with #{network}"
            expect(page).to have_content 'Add your email address for sign in'
            fill_in 'Email', with: user.email
            click_on 'Add email'
            expect(page).to have_content 'Email has already been taken'
          end
        end
      end
    end
  end
end
