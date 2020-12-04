class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    @question.save ? head(:ok) : head(422)
  end

  def update
    @question.update(question_params) ? head(:ok) : head(422)
  end

  def destroy
    @question.destroy ? head(:ok) : head(422)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[name url])
  end

  def question
    @question = Question.with_attached_files.find(params[:id])
  end
end
