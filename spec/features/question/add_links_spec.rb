require 'rails_helper'

feature 'User can add links to question', %q{
In order to provide additional info to my question
As an question`s author
I`d like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43.js' }
  given(:wrong_url) { 'gist_github.com' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds link when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User add link with errors' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Name', with: ''
    fill_in 'Url', with: wrong_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to have_content "Links name can't be blank"
  end
end
