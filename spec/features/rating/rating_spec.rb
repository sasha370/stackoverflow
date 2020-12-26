require 'rails_helper'

feature 'User can rate answer or question', %q{
Any question can be rated
by registered user
} do

  describe 'Auth user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote +1 for question' do
      click_link thumb_up_question_path(question)
      # expect("div#question_#{question.id}_rating").to eq 1
    end

    scenario 'can vote -1 for question'
    scenario 'can cancel his choice'

  end

  # describe 'unAuth user' do
  #   scenario 'can`t vote for question'
  #   scenario 'can`t vote for answer'
  # end

end
