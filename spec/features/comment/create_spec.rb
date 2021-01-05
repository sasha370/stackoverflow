require 'rails_helper'

feature 'User can create comment', %q{
    In order to comment question or answer  as an authenticates user
    I `d like to be able to add it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Auth user can add comment' do

    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'to question' do
      fill_in 'Comment', with: 'My comment'
      click_on 'Add comment'

      expect(page).to have_content 'My comment'
    end

    scenario 'to answer'
  end

  describe 'NonAuth user can`t add comment' do
    scenario 'and don`t see any button'
  end

end
