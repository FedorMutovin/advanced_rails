require 'rails_helper'
describe 'Answers API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  let(:user) { create(:user) }
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question, author: user) }
  let(:resource) { Answer }

  describe 'GET /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].min_by { |hash| hash['id'].to_i } }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq(2)
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq(answer.author.id)
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_link, :with_files, question: question, author: user) }
    let!(:comment) { create(:comment, commentable: answer, user: answer.author) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { api_v1_answer_path(answer) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    context 'when authorized' do
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns only one answer' do
        expect(json.size).to eq(1)
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq(answer.send(attr).as_json)
        end
      end

      it_behaves_like 'API resource contains' do
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      it_behaves_like 'API Create resource' do
        let(:method) { :post }
        let(:valid_attrs) { { body: 'body' } }
        let(:invalid_attrs) { { body: '' } }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_files, :with_link, question: question, author_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let!(:comment) { create(:comment, commentable: answer, user: answer.author) }
      let(:valid_attrs) { { body: 'body', user_id: access_token.resource_owner_id } }

      let(:invalid_attrs) { { body: '' } }

      it_behaves_like 'API Update resource' do
        let(:method) { :patch }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_files, :with_link, question: question, author_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      it_behaves_like 'API Destroy resource' do
        let(:method) { :delete }
      end
    end
  end
end
