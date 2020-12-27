require 'rails_helper'

feature 'User can rate answer or question', %q{
Any question can be rated
by registered user
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Auth user' do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'can vote +1 for question', js: true do
      find_link(href: thumb_up_question_path(question)).click
      sleep 1
      expect(question.rating).to eq 1
    end

    scenario 'can vote -1 for question', js: true do
      find_link(href: thumb_down_question_path(question)).click
      sleep 1
      expect(question.rating).to eq -1
    end

    scenario 'can cancel his choice', js: true do
      question.vote_plus(another_user)
      visit question_path(question)
      find_link(href: cancel_voice_question_path(question)).click
      sleep 3
      expect(question.rating).to eq 0
    end
  end

  describe 'unAuth user' do
    scenario 'can`t vote for question' do
      visit question_path(question)
      expect(page).to have_no_link("rating_buttons_#{question.name_id}")
      expect(page).to have_no_link("cancel_rating_#{question.name_id}")
    end

    scenario 'can`t vote for answer' do
      visit question_path(question)
      expect(page).to have_no_link("rating_buttons_#{answer.name_id}")
      expect(page).to have_no_link("cancel_rating_#{answer.name_id}")
    end
  end
end

