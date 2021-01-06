require 'rails_helper'

feature 'User can create question', %q{
    In order to get answer from a community as an authenticates user
    I `d like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Auth user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'ask a question with attached files' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'text text text'
      attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions ', js: true do
    scenario 'question added on another user`s page', js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('another_user') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'question[title]', with: 'Test question'
        fill_in 'question[body]', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('another_user') do

        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'UnAuth user tried asks a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
