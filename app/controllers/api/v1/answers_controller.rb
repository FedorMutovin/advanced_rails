class Api::V1::AnswersController < Api::V1::BaseController
  before_action :question
  before_action :answers
  authorize_resource

  def index
    render json: @answers, each_serializer: AnswersSerializer
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answers
    @answers ||= question.answers
  end
end
