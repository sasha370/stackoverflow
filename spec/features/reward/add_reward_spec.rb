require 'rails_helper'

feature 'User can add reward for best answer', %q(
     As author of question
  I`d like to be able create reward
for best answer
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:answer) { create(:answer, question: question, user: another_user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }
  given!(:reward) { question.create_reward(title: 'For smt', image: create_file_blob) }
  let(:first_answer) { page.find(:css, 'div.best_answer') }

  background do
    sign_in(user)
  end

  scenario 'Author add reward when create question' do
    visit new_question_path
    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'text text text'
    fill_in 'question[reward_attributes][title]', with: 'for best answer'
    attach_file('question[reward_attributes][image]', "#{Rails.root}/spec/fixtures/files/image.jpg")

    click_on 'Ask'

    expect(page).to have_content 'for best answer'
    expect(page).to have_css("img[alt='image.jpg']")
  end

  scenario 'edits his question with add reward' do
    visit edit_question_path(question)
    fill_in 'question[reward_attributes][title]', with: 'for best answer'
    attach_file('question[reward_attributes][image]', "#{Rails.root}/spec/fixtures/files/image.jpg")
    click_on 'Ask'

    expect(page).to have_content 'for best answer'
    expect(page).to have_css("img[alt='image.jpg']")
  end

  context 'With best answer' do

    background do
      visit question_path(question)
      click_on(id: "best_#{answer.id}")
    end

    scenario 'the best answer have reward of question', js: true do
      expect(first_answer).to have_content reward.title
      expect(first_answer).to have_css("img[alt='image.jpg']")
    end

    scenario 'author of best question have reward', js: true do
      sleep 2
      expect(another_user.answers.best.count).to eq 1
    end

    scenario 'author of best answer haven`t` reward when choose another best', js: true do
      click_on(id: "best_#{another_answer.id}")
      sleep 5
      expect(another_user.answers.best.count).to eq 0
    end
  end
end
