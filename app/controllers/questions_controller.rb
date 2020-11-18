class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show new update destroy]
  after_action :publish_question, only: [:create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question.links.build
    @question.reward = Reward.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user&.author?(@question)
    @questions = Question.all
  end

  def destroy
    if current_user&.author?(@question) && @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render questions_path
    end
  end

  private

  def set_question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
    gon.question_id = @question.id
    gon.user_id = current_user.id if current_user
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url],
                                                    reward_attributes: %i[name image])
  end

  def publish_question
    return if @question.errors.any?

    renderer = ApplicationController.renderer_with_signed_in_user(current_user)
    ActionCable.server.broadcast(
      'questions',
      renderer.render(
        partial: 'questions/question',
        locals: { question: @question, current_user: nil }
      )
    )
  end
end
