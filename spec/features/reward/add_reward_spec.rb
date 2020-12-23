require 'rails_helper'

feature 'User can add reward for best answer', %q(
     As author of question
  I`d like to be able create reward
for best answer
) do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Author add reward when create question' do
    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'text text text'
    fill_in 'question[reward_attributes][title]', with: 'for best answer'
    attach_file('question[reward_attributes][image]', "#{Rails.root}/spec/fixtures/files/image.jpg")

    click_on 'Ask'

    expect(page).to have_content 'for best answer'
    expect(page).to have_css("img[alt='image.jpg']")
  end
end
