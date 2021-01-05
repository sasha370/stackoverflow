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
      within(id: "new_#{question.name_id}_comment_field") do
        fill_in id: "comment_body", with: 'My comment'
        click_on 'Commit'
      end

      expect(page).to have_content 'My comment'
    end

    scenario 'to answer' do
      within(id: "new_#{answer.name_id}_comment_field") do
        fill_in id: "comment_body", with: 'My comment for answer'
        click_on 'Commit'
      end

      expect(page).to have_content 'My comment for answer'
    end
  end

  describe 'NonAuth user can`t add comment' do
    scenario 'and don`t see any button' do
      visit question_path(question)
      expect(page).to have_no_field(id: "new_question_comment")
    end
  end
end
