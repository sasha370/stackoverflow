class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @questions = Question.created_in_last_day

    if @questions.empty?
      mail template_name: 'empty_digest'
    end

    mail to: user.email,
         subject: 'Daily Digest from Stackoverflow'
  end
end
