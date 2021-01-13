require 'rails_helper'

feature 'User can create comment', %q{
    In order to comment question or answer  as an authenticates user
    I `d like to be able to add it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Auth user can add comment', js: true do

    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'to question' do
        click_link 'Add comment'
        fill_in id: "comment_body", with: 'My comment'
        click_on 'Commit'

      expect(page).to have_content 'My comment'
    end

    scenario 'to answer' do
        click_link 'Add comment'
        fill_in id: "comment_body", with: 'My comment for answer'
        click_on 'Commit'

      expect(page).to have_content 'My comment for answer'
    end
  end

  describe 'multiple sessions ' do
    scenario 'comment added on another user`s page', js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_link 'Add comment'
          fill_in id: "comment_body", with: 'My comment'
          click_on 'Commit'

        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content( 'My comment').once
      end
    end
  end

  describe 'NonAuth user can`t add comment' do
    scenario 'and don`t see any button' do
      visit question_path(question)
      expect(page).to have_no_link 'Add comment'
    end
  end
end
