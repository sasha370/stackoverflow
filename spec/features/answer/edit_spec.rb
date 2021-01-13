require 'rails_helper'

feature 'User ca edit his answer', %q{
In order to correct mistakes
As an author of answer
I`d like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Auth user' do
    before do
      answer.files.attach(create_file_blob)
      sign_in(user)
      visit question_path(question)
      click_link(class: 'edit_link', id: answer.id)
    end

    scenario 'edits his answer', js: true do
      within(:xpath, '//ul[@id="answers"]') do
        fill_in "Edit answer", with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within(:xpath, '//ul[@id="answers"]') do
        fill_in "Edit answer", with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edit an answer with attached files', js: true do
      within(:xpath, '//ul[@id="answers"]') do
        fill_in "Edit answer", with: 'Edited Answer'
        # attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        find("#answer_files").send_keys("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edit a answer for delete attached files', js: true do
      within(:xpath, "//form[@id=\"edit_form_#{answer.id}\"]") do
        click_on(id: "delete_link_#{answer.files[0].id}")
        accept_alert
        expect(page).to have_no_link answer.files[0].filename.to_s
      end
    end
  end

  scenario 'tries to edit other user`s question' do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to have_no_link(class: 'edit_link', id: answer.id)
  end

  scenario 'UnAuth user can not edit answer' do
    visit question_path(question)
    expect(page).to have_no_link(class: 'edit_link', id: answer.id)
  end
end
