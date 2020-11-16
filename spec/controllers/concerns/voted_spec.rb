require 'rails_helper'

shared_examples 'voted' do
  describe 'POST #vote_for' do
    context 'Not author can vote for question/answer' do
      before { login(other_user) }

      it 'Voting for question/answer' do
        expect { post :vote_for, params: { id: resource }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context "Author can't vote for question/answer" do
      before { login(user) }

      it 'Voting for question/answer error' do
        post :vote_for, params: { id: resource }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'POST #vote_against' do
    context "Not author can't vote against" do
      before { login(other_user) }

      it 'Voting against question/answer' do
        expect { post :vote_against, params: { id: resource }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context 'Author can not vote against' do
      before { login(user) }

      it 'Voting against question/answer error' do
        patch :vote_against, params: { id: resource }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'DELETE #delete_vote' do
    let!(:vote) { create(:vote, user: other_user, voteable: resource) }
    context "Not author of vote can delete his vote" do
      before { login(other_user) }

      it 'delete vote' do
        expect { delete :delete_vote, params: { id: resource }, format: :json }.to change(Vote, :count).by -1
      end
    end

    context 'Author of question/answer can not delete vote' do
      before { login(user) }

      it 'not delete vote' do
        delete :delete_vote, params: { id: resource }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

end
