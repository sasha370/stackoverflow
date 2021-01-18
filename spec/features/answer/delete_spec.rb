require 'rails_helper'

feature 'User can delete answer', %q{
To manage the answer
I want to be able to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_user) { create(:user) }

  scenario 'answer deleted by author', js: true do
    sign_in(user)
    visit question_path(question)
    click_link(class: 'delete_link', id: answer.id)
    accept_alert

    expect(page).to have_no_content answer.body
  end

  scenario 'answer can`t be deleted by other users`', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to have_no_link(class: 'delete_link', id: answer.id)
  end
end
