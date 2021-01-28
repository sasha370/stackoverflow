require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "question_notification" do
    let(:user) { create(:user) }
    let(:question){create(:question)}
    let(:answer){create(:answer, question: question)}
    let!(:mail) { NotificationMailer.question_notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Updating by your subscription")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@sandbox3c57011901204e1c986432759bbce859.mailgun.org"])
    end
  end

end
