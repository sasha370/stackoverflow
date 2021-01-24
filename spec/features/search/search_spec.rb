require 'rails_helper'

feature 'User can search for answers throughout site ', %q(
  any user should be able to search by keyword \ phrase throughout the site
) do

  given!(:questions) { create_list(:question, 2, title: 'lorem ipsum') }
  given!(:answers) { create_list(:answer, 2, body: 'lorem sengue') }
  given!(:comments) { create_list(:comment, 2, body: 'loremdaser') }
  given!(:user) { create(:user, email: 'lorem@test.ru') }

  describe 'search from Navbar' do
    scenario 'directly search' do
      visit root_path
      fill_in "query", with: 'lorem'
      click 'Search'

      expect(page).to have_context "Search result"
      expect(page).to have_context("lorem").exactly(5).times
    end
  end

  describe 'Advanced Search' do
    scenario 'search only among questions'
    scenario 'search only among answers'
    scenario 'search only among comments'
    scenario 'search only among users'

  end
end
