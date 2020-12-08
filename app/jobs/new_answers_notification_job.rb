class NewAnswersNotificationJob < ApplicationJob
  queue_as :default

  def perform(user, answer)
    NewAnswersNotification.new.send_notification(user, answer)
  end
end
