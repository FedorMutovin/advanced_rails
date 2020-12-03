class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end
end
