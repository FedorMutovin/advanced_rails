class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[new create destroy]
  before_action :set_answer, only: %i[destroy update mark_best]
  before_action :set_answer_question, only: %i[destroy update mark_best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  include Voted

  def new; end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def destroy
    @answer.destroy
    @answers = @question.answers
  end

  def update
    @answer.update(answer_params)
  end

  def mark_best
    @answer.mark_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :author, files: [], links_attributes: %i[name url])
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

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answer_question_#{@question.id}",
      answer: @answer,
      links: @answer.links,
      user_id: current_user.id
    )
  end
end
