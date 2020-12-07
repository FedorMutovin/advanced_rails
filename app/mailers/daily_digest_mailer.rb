class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.all.map(&:title)

    mail to: user.email
  end
end
