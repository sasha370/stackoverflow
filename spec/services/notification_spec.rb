require 'rails_helper'

RSpec.describe NotificationService do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:users) { create_list(:user, 3) }

  before do
    users.each do |user|
      question.subscriptions.create(user: user)
    end
  end

  it 'sends email notification to all subscribed user' do
    users.each do |user|
      expect(NotificationMailer).to receive(:question_notification).with(user, answer).and_call_original
    end
    subject.send_notifications(answer)
  end
end
