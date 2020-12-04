class Api::V1::AnswersController < Api::V1::BaseController
  before_action :question, only: %i[index create]
  before_action :answers, only: :index
  before_action :answer, only: %i[show update destroy]
  authorize_resource

  def index
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_resource_owner))
    @answer.save ? head(:ok) : head(422)
  end

  def update
    @answer.update(answer_params) ? head(:ok) : head(422)
  end

  def destroy
    @answer.destroy ? head(:ok) : head(422)
  end

  private

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: %i[name url])
  end

  def answers
    @answers ||= @question.answers
  end
end
