require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, author: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_link, :with_files, author: user) }
    let(:answer) { create(:answer, :with_link, :with_files, author: user) }
    let!(:comment) { create(:comment, commentable: question, user: question.author) }
    let(:question_response) { json['question'] }
    let(:api_path) { api_v1_question_path(question) }
    let(:access_token) { create(:access_token) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    context 'when authorized' do
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns only one question' do
        expect(json.size).to eq(1)
      end

      it_behaves_like 'API resource contains' do
        let(:resource_response) { question_response }
        let(:resource) { question }
        let(:resource_attributes) { %w[id title body created_at updated_at] }
      end
    end
  end
end
