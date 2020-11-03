class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create destroy]
  before_action :set_answer, only: %i[destroy update mark_best]
  before_action :set_answer_question, only: %i[destroy update mark_best]

  def new; end

  def create
    @answer = @question.answers.new(answer_params.merge(author: current_user))
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @answer.destroy if current_user&.author?(@answer)
    @answers = @question.answers
  end

  def update
    @answer.update(answer_params) if current_user&.author?(@answer)
  end

  def mark_best
    @answer.mark_best if current_user&.author?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :author, files: [], links_attributes: [:name, :url])
  end

  def set_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : Question.new
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_answer_question
    @question = @answer.question
  end
end
