class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_question_#{data['question_id']}"
  end
end
