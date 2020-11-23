# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote, Reward]
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :mark_best, Answer, question: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :read, Reward

    can :destroy, ActiveStorage::Attachment do |file|
      user.id.eql?(file.record.author_id)
    end

    can [:vote_for, :vote_against], [Question, Answer] do |voteable|
      !user.id.eql?(voteable.author_id) && !voteable.votes.exists?(user_id: user.id)
    end

    can :delete_vote, [Question, Answer] do |voteable|
      voteable.votes.find_by(user_id: user.id)
    end
  end
end
