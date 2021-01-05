require 'rails_helper'

feature 'User can remove comment', %q{
   I `d like to be able to remove my comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:comment) { question.comments.create(body: 'Test comment', user: user) }

  describe 'Auth user', js: true do

    scenario 'can remove comment if author' do
      sign_in(user)
      visit question_path(question)
      click_on(id: "delete_comment_#{comment.id}")
      accept_alert

      expect(page).to have_no_content 'Test comment'
    end

    scenario 'can`t remove comment if not Author ' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to have_no_link(id: "delete_comment_#{comment.id}")
    end
  end
end
