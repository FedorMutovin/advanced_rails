require 'rails_helper'

RSpec.describe User, type: :model do
  let(:other_answer) { create(:answer, question: other_question, author: other_author) }
  let(:other_question) { create(:question, author: other_author) }
  let(:other_author) { create(:user) }
  let(:author_answers) { create(:answer, question: author_questions, author: author) }
  let(:author_questions) { create(:question, author: author) }
  let(:author) { create(:user) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many :answers }
  it { is_expected.to have_many :questions }
  it { is_expected.to have_many(:rewards) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }

  it 'User is author of question' do
    expect(author).to be_author(author_questions)
  end

  it 'User is not author of question' do
    expect(author).not_to be_author(other_question)
  end

  it 'User is author of answer' do
    expect(author).to be_author(author_answers)
  end

  it 'User is not author of answer' do
    expect(author).not_to be_author(other_answer)
  end

  describe '.find_for_ouath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
