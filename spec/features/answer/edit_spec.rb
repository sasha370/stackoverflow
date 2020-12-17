require 'rails_helper'

feature 'User ca edit his answer', %q{
In order to correct mistakes
As an author of answer
I`d like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Auth user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_link "#{answer.id}"

      within(:xpath, '//ul[@id="answers"]') do
        fill_in "Edit answer", with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario 'tries to edit other user`s question'
  end

  scenario 'UnAuth can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


end
