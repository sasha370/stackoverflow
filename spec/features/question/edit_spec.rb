require 'rails_helper'

feature 'User can edit his question', %q{
In order to correct mistakes
As an author of question
I`d like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/sasha370/370381473ad4e3cd5fc9eda5691b3c43.js' }

  describe 'Auth user' do
    before do
      sign_in(user)
      visit edit_question_path(question)
    end

    scenario 'edits his question with correct data' do
      fill_in 'question[title]', with: 'edited title'
      fill_in 'question[body]', with: 'edited body'
      click_on 'Ask'

      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'edits his answer with errors' do
      fill_in 'question[title]', with: ''
      fill_in 'question[body]', with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edit a question with attached files' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'text text text'
      attach_file 'question[files][]', ["spec/rails_helper.rb", "spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edit a question for delete attached files', js: true do
      question.files.attach(create_file_blob)
      visit edit_question_path(question)
      click_on(id: "delete_link_#{question.files[0].id}")
      page.accept_alert

      expect(page).to have_no_link question.files[0].filename.to_s
    end
  end

  scenario 'UnAuth can not edit answer' do
    sign_in(another_user)
    visit edit_question_path(question)
    expect(page).to have_content 'You are not authorized to access this page.'
  end
end
