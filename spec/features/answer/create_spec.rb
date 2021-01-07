require 'rails_helper'

feature 'User can create answer', %q{
    To respond on question as an authenticating user
    I must be able to fill out a answer form
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Auth user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'new_form', with: 'Answer for question'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer for question'
    end

    scenario 'ask an answer with attached files', js: true do

      fill_in 'new_form', with: 'Answer for question'
      # page.attach_file(  "#{Rails.root}/spec/rails_helper.rb", make_visible: true)
      find("#answer_files").send_keys("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content 'Your have an errors!'
    end
  end

  describe 'multiple sessions ' do
    scenario 'answer added on another user`s page', js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'new_form', with: 'Answer for question'
        click_on 'Create answer'

        expect(page).to have_content 'Your answer successfully created.'
        expect(page).to have_content 'Answer for question'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Answer for question'
      end
    end
  end

  scenario 'UnAuth user tries to answers the question' do
    visit question_path(question)
    expect(page).to have_no_content 'Create answer'
  end
end
