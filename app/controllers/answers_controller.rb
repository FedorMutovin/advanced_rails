class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create destroy]
  before_action :set_answer, only: %i[destroy update]

  def new; end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully deleted.'
    else
      render 'questions/show'
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :author)
  end

  def set_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
