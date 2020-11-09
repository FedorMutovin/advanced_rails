module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[vote_for vote_against delete_vote]
  end

  def vote_for
    vote(1)
  end

  def vote_against
    vote(-1)
  end

  def delete_vote
    vote = @voteable.votes.find_by(user: current_user)
    return render json: { error: "You can't delete vote"}, status: 403 unless vote&.destroy
  end

  def vote(value)
    return render json: { error: "You can't vote for your #{model_klass.to_s.downcase}" }, status: 403 if current_user.author?(@voteable)
    return render json: { error: "You can't vote twice" }, status: 403 if @voteable.votes.find_by(user: current_user)

    @voteable.votes.create(user: current_user, value: value)

    render json: { votes_sum: @voteable.votes.sum(:value), id: @voteable.id }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
