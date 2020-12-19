require 'rails_helper'

feature 'User can choose best answer', %q{
To display the best answer first in the list
I can mark it as the owner of the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:best_answer) { create(:answer, question: question, user: user, best: true, body: 'Best Answer Body') }
  let(:first_answer) { page.find(:css, 'div.best_answer') }

  describe 'Auth user' do
    scenario 'Mark only one answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on(id: "best_#{answer.id}")

      expect(page).to have_css('div.best_answer')
      expect(first_answer).to have_content answer.body
    end

    scenario 'chooses another answer as the best one', js: true do
      sign_in(user)
      visit question_path(question)
      click_on(id: "best_#{another_answer.id}")

      expect(first_answer).to have_content another_answer.body
    end

    scenario 'user tries to set the best answer for not his question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answer.id}")
    end

    scenario 'UnAuth user tries to set the best answer' do
      visit question_path(question)

      expect(page).to_not have_link(id: "best_#{answer.id}")
    end
  end
end
