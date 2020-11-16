require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let!(:question) { create :question, author: user }

  describe 'POST #create' do
    context 'Authenticated user posts a comment' do
      before { login user }

      context 'with valid attributes' do
        it 'saves new comment' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }
              .to change(question.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save comment to the database' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }
              .to_not change(question.comments, :count)
        end
      end
    end

    context 'Unuthenticated user' do
      it 'does not create a comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }
            .to_not change(question.comments, :count)
      end

      it 'gets an invalid response' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js

        expect(response.status).to eq 401
      end
    end
  end
end
