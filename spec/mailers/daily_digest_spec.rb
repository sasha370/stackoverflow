require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily Digest from Stackoverflow")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["budka52@bk.ru"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello! It`s a daily digest from Stackoverflow")
    end
  end

end
