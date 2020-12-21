require 'rails_helper'

feature 'User can add links to question', %q{
In order to provide additional info to my question
As an question`s author
I`d like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43.js' }
  given(:gist_url_2) { 'https://github.com' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds several links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url

    within(:xpath, '//div[@id="add_link"]') do
      click_on 'Add link'
      fill_in 'Name', with: 'My gist2'
      fill_in 'Url', with: gist_url_2
    end
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My gist2', href: gist_url_2
  end
end
