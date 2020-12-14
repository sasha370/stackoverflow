require 'rails_helper'

feature 'User can create answer', %q{
    To respond on question as an authenticating user
    I must be able to fill out a answer form
} do

  given(:user) { build(:user) }
  given(:question) { create(:question) }

  describe 'Auth user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Add answer', with: 'Answer for question'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer for question'
    end

    scenario 'answers the question with errors' do
      click_on 'Create answer'
      expect(page).to have_content 'Your answer have an errors!'
    end
  end

  scenario 'UnAuth user tries to answers the question'

end
