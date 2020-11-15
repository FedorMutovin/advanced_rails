class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create destroy]
  before_action :set_answer, only: %i[destroy update mark_best]
  before_action :set_answer_question, only: %i[destroy update mark_best]
  after_action :publish_answer, only: [:create]

  include Voted

  def new; end

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user))
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

  def publish_answer
    return if @answer.errors.any?

    renderer = ApplicationController.renderer_with_signed_in_user(current_user)

    @question = @answer.question

    AnswersChannel.broadcast_to(
        @question,
        {
            author_id: @answer.author.id,
            body: renderer.render(partial: 'answers/guest_answer', locals: { answer: @answer })
        }
    )
  end
end
