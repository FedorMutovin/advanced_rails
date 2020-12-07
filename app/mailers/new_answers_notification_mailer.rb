class NewAnswersNotificationMailer < ApplicationMailer
  def send_notification(user, answer)
    @answer = answer

    mail to: user.email, subject: "New answer"
  end
end
