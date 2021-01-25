require 'sphinx_helper'

feature 'User can search for answers throughout site ', %q(
  any user should be able to search by keyword \ phrase throughout the site
) do

  given!(:questions) { create_list(:question, 3, title: 'lorem ipsum') }
  given!(:answers) { create_list(:answer, 2, body: 'lorem sengue') }
  given!(:comments) { create_list(:comment, 2, body: 'loremdaser', commentable: questions[0]) }
  given!(:user) { create(:user, email: 'lorem@test.ru') }

  shared_examples_for "Search with params" do |query, times|
    scenario 'fill form and send request' do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in "query", with: query
        click_on 'Search'

        expect(page).to have_content(query).exactly(times).times
      end
    end
  end

  context 'by all categories', sphinx: true do
    it_should_behave_like "Search with params", 'lorem', 6
  end

  context 'search only among questions', sphinx: true do
    it_should_behave_like "Search with params", 'ipsum', 3
  end

  context 'search only among answers', sphinx: true do
    it_should_behave_like "Search with params", 'sengue', 2
  end

  context 'search only among comments', sphinx: true do
    it_should_behave_like "Search with params", 'loremdaser', 2
  end

  context 'search only among users', sphinx: true do
    it_should_behave_like "Search with params", 'test', 1
  end
end
