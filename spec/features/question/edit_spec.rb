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
    before do
      sign_in(user)
      visit edit_question_path(question)
    end

    scenario 'edits his question with correct data' do
      fill_in "Title", with: 'edited title'
      fill_in "Body", with: 'edited body'
      click_on 'Ask'

      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'edits his answer with errors' do
      fill_in "Title", with: ''
      fill_in "Body", with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edit a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edit a question for delete attached files', js: true do
      question.files.attach(create_file_blob)
      visit edit_question_path(question)
      click_on(id: "delete_attach_#{question.files[0].id}")

      click_on 'Ask'
      expect(page).to have_no_link question.files[0].filename.to_s
    end
  end

  scenario 'UnAuth can not edit answer' do
    sign_in(another_user)
    visit edit_question_path(question)
    expect(page).to_not have_link 'Ask'
  end
end
