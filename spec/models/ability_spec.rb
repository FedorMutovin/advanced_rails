require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
  end

  describe 'user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create :question, author: other_user }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create :answer, question: question, author: other_user }
    let(:link_question) { create :google_link, linkable: question }
    let(:other_link_question) { create :google_link, linkable: other_question }
    let(:link_answer) { create :google_link, linkable: answer }
    let(:other_link_answer) { create :google_link, linkable: other_answer }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
    it { is_expected.to be_able_to :create, Vote }
    it { is_expected.to be_able_to :create, Reward }
    it { is_expected.to be_able_to :read, Reward }
    it { is_expected.to be_able_to :vote_for, Question }
    it { is_expected.to be_able_to :vote_against, Question }
    it { is_expected.to be_able_to :vote_for, Answer }
    it { is_expected.to be_able_to :vote_against, Answer }

    it { is_expected.to be_able_to :update, question }
    it { is_expected.not_to be_able_to :update, other_question }
    it { is_expected.to be_able_to :destroy, question, user: user }
    it { is_expected.not_to be_able_to :destroy, other_question, user: user }
    it { is_expected.to be_able_to :destroy, link_question }
    it { is_expected.not_to be_able_to :destroy, other_link_question }
    it { is_expected.to be_able_to :vote_for, other_question }
    it { is_expected.to be_able_to :vote_against, other_question }

    it { is_expected.to be_able_to :update, answer }
    it { is_expected.not_to be_able_to :update, other_answer }
    it { is_expected.to be_able_to :destroy, answer }
    it { is_expected.not_to be_able_to :destroy, other_answer }
    it { is_expected.to be_able_to :mark_best, answer }
    it { is_expected.not_to be_able_to :mark_best, create(:answer, author: other_user, question: other_question) }
    it { is_expected.to be_able_to :destroy, link_answer }
    it { is_expected.not_to be_able_to :destroy, other_link_answer }
    it { is_expected.to be_able_to :vote_for, other_answer }
    it { is_expected.to be_able_to :vote_against, other_answer }
    it { is_expected.to be_able_to :destroy, ActiveStorage::Attachment }
  end
end
