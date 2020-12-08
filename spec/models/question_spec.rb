require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'commentable'

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_one(:reward).dependent(:destroy) }
  it { is_expected.to belong_to :author }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :reward }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'reputation' do
    let(:question) { build(:question, author: user) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'subscribed?' do
    let!(:subscription) { create(:subscription, question: question, user: user) }

    it 'true' do
      expect(question).to be_subscribed(user)
    end

    it 'false' do
      expect(question).to_not be_subscribed(other_user)
    end
  end

  describe 'subscription(user)' do
    it 'be found' do
      expect(question.subscription(user)).to eq question.subscriptions.first
    end

    it 'return nil' do
      expect(question.subscription(other_user)).to eq nil
    end
  end
end
