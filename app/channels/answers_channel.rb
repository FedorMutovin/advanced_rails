class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answer_question_#{data['question_id']}"
  end
end
