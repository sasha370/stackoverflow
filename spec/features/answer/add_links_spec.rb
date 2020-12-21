require 'rails_helper'

feature 'User can add links to answer', %q{
In order to provide additional info to my answer
As an answer`s author
I`d like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43.js' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'new_form', with: 'Answer for question'
    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create answer'
    within(:xpath, '//ul[@id="answers"]') do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
