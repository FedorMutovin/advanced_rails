require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let!(:rewards) { create_list(:reward, 2, question: question, answer: answer) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'get all rewards' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
