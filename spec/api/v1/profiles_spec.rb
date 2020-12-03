require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'dose not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    let(:me) { create(:user) }
    let!(:users) { create_list(:user, 4) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:user_response) { json['users'].first }
    let(:user) { users.first }
    let(:api_path) { '/api/v1/profiles/' }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      %w[id email created_at updated_at].each do |attr|
        expect(user_response[attr]).to eq user.send(attr).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(user_response).not_to have_key(attr)
      end
    end

    it 'users list not contains current user' do
      json.each do |user|
        expect(user).not_to include('id' => me.id)
      end
    end
  end
end
