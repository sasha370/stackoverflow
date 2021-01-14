require 'rails_helper'

feature 'Guest can sign up', %q{
    To use the full functionality, I`d must be able to register
} do

  scenario 'Guest tries to register with correct data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'tests@test.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  describe 'Guest already registered' do
    given(:user) { create(:user) }

    scenario 'tries to reRegister as new user' do
      visit new_user_registration_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '654321'
      fill_in 'Password confirmation', with: '654321'
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end

  describe 'Register with Omniauth services' do

    scenario 'GitHub' do
      mock_auth_hash_github
      visit new_user_registration_path
      click_link "Sign in with GitHub"

      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario "can handle authentication error with GitHub" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_registration_path
      click_link "Sign in with GitHub"
      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
    end

    scenario "GoogleOauth" do
      mock_auth_hash_google
      visit new_user_registration_path
      click_link "Sign in with GoogleOauth2"

      expect(page).to have_content 'Successfully authenticated from Google account.'
    end

    scenario "can handle authentication error with GoogleOauth2" do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      visit new_user_registration_path
      click_link "Sign in with GoogleOauth2"
      expect(page).to have_content 'Could not authenticate you from GoogleOauth2 because "Invalid credentials"'
    end
  end
end
