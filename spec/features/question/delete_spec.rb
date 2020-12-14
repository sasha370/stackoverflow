require 'rails_helper'

feature 'User can delete question', %q{
    To manage the question
I want to be able to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'question deleted by author' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_no_content question.title
    expect(page).to have_content 'Question was successfully deleted.'
  end

end
