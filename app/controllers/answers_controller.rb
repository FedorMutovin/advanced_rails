class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create destroy]
  before_action :set_answer, only: %i[destroy update mark_best]
  before_action :set_answer_question, only: %i[destroy update mark_best]

  def new; end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    @answer.destroy if current_user&.author?(@answer)
  end

  def update
    @answer.update(answer_params) if current_user&.author?(@answer)
  end

  def mark_best
    @answer.mark_best if current_user&.author?(@answer) && current_user&.author?(@answer.question)
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

  def set_answer_question
    @question = @answer.question
  end
end
