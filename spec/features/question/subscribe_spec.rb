require 'rails_helper'

feature 'User can subscribe for question', %q{
User can subscribe\unsubscribe  to update question
} do

  describe 'Auth user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    it 'have link to subscribe' do
      expect(page).to have_link 'Subscribe'
    end

    it 'notified after subscribing' do
      click_link 'Subscribe'
      expect(page).to have_content "You were subscribed to this question"
    end

    context 'if user already subscribe ' do
      given!(:subscription) { question.subscriptions.create(user: user) }

      it 'notified after subscribing' do
        click_link 'Subscribe'
        expect(page).to have_content "You were Unsubscribed from this question"
      end
    end
  end

  describe 'Not Auth user' do
    given(:question) { create(:question) }

    it 'have link to subscribe' do
      visit question_path(question)
      expect(page).to have_no_link 'Subscribe'
    end
  end
end
