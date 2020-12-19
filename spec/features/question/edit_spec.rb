require 'rails_helper'

feature 'User can edit his question', %q{
In order to correct mistakes
As an author of question
I`d like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Auth user' do
    scenario 'edits his question with correct data' do
      sign_in(user)
      visit edit_question_path(question)

      fill_in "Title", with: 'edited title'
      fill_in "Body", with: 'edited body'
      click_on 'Ask'

      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'edits his answer with errors' do
      sign_in(user)
      visit edit_question_path(question)
      fill_in "Title", with: ''
      fill_in "Body", with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'UnAuth can not edit answer' do
    sign_in(another_user)
    visit edit_question_path(question)
    expect(page).to_not have_link 'Ask'
  end
end
