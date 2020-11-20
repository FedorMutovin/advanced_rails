class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: %i[create]
  after_action :publish_comment, only: %i[create]

  def create
    @comment = @resource.comments.create(comment_params.merge(user: current_user))
  end

  private

  def find_resource
    @klass = [Question, Answer].find { |klass| params["#{klass.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    @question = @resource.class.name.downcase.eql?('question') ? @resource : @resource.question

    ActionCable.server.broadcast(
      "comment_question_#{@question.id}",
      comment: @comment,
      user_id: current_user.id,
      resource_id: @resource.id,
      resource_type: @resource.class.name.downcase
    )
  end
end
