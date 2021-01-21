# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/question_notification
  def question_notification
    user = User.first
    answer = Answer.first
    NotificationMailer.question_notification(user,answer)
  end
end
