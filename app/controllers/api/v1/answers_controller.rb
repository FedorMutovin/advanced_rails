class Api::V1::AnswersController < Api::V1::BaseController
  before_action :answers, only: :index
  before_action :answer, only: :show
  authorize_resource

  def index
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : answers.build(answer_params)
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: %i[name url])
  end

  def answers
    @answers ||= question.answers
  end
end
