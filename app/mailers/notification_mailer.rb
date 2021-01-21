class NotificationMailer < ApplicationMailer

  def question_notification(user,answer)
    @question = answer.question
    @answer = answer

    mail to: user.email,
         subject: 'Updating by your subscription'
  end
end
