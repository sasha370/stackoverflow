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
    open_email('tests@test.ru')
    current_email.click_on 'Confirm my account'


    fill_in 'Email', with: 'tests@test.ru'
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
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

    describe 'GitHub' do
      scenario 'with correct data' do
        mock_auth_hash('github', email: 'test@test.ru')
        visit new_user_registration_path
        click_link "Sign in with GitHub"

        expect(page).to have_content 'Successfully authenticated from GitHub account.'
      end

      scenario "can handle authentication error with GitHub" do
        invalid_mock('github')
        visit new_user_registration_path
        click_link "Sign in with GitHub"
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end

    describe 'GoogleOauth' do
      scenario "with correct data" do
        mock_auth_hash('google_oauth2', email: 'test@test.ru')
        visit new_user_registration_path
        click_link "Sign in with GoogleOauth2"

        expect(page).to have_content 'Successfully authenticated from Google account.'
      end

      scenario "can handle authentication error with GoogleOauth2" do
        invalid_mock('google_oauth2')
        visit new_user_registration_path
        click_link "Sign in with GoogleOauth2"

        expect(page).to have_content 'Could not authenticate you from GoogleOauth2 because "Invalid credentials"'
      end
    end

    describe 'Vkontakte' do
      scenario "with correct data, without email" do
        mock_auth_hash('vkontakte', email: nil)
        visit new_user_registration_path
        click_link "Sign in with Vkontakte"
        fill_in 'user_email', with: 'tests@test.ru'
        click_on 'Send confirmation to email'

        open_email('tests@test.ru')
        current_email.click_link 'Confirm my account'
        click_link "Sign in with Vkontakte"

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario "can handle authentication error with Vkontakte" do
        invalid_mock('vkontakte')
        visit new_user_registration_path
        click_link "Sign in with Vkontakte"

        expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      end
    end
  end
end
