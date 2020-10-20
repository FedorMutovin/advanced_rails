class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create destroy]

  def new; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully deleted.'
    else
      render 'questions/show'
    end

  end

  private

  def answer_params
    params.require(:answer).permit(:body, :author)
  end

  def set_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end
end
