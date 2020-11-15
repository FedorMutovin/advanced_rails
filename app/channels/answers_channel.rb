class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question = GlobalID::Locator.locate(params[:id])
    stream_for question
  end
end
