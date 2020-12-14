require 'rails_helper'

feature 'User can delete answer', %q{
To manage the answer
I want to be able to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given(:another_user) { create(:user) }

  scenario 'answer deleted by author' do
    sign_in(user)
    visit question_path(question)
    click_link("delete_answer_#{answer.id}")

    expect(page).to have_no_content answer.body
    expect(page).to have_content 'Answer was successfully deleted.'
  end

end
