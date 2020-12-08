class NewAnswersNotification
  def send_notification(user, answer)
    NewAnswersNotificationMailer.send_notification(user, answer).deliver_later
  end
end
