require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in(user) }

      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { sign_in(user) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), author: user }, format: :js }.to_not change(Answer, :count)
      end
      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end

    end

    context 'without sign in' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), author: user }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), author: user, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    before { sign_in(user) }

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  # describe 'DELETE #destroy' do
  #
  #   let!(:answer) { create(:answer, question: question, author: user) }
  #
  #   context 'with sign in' do
  #     before { login(user) }
  #
  #     it 'deletes the answer' do
  #       expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
  #     end
  #
  #     it 'redirects to question' do
  #       delete :destroy, params: { id: answer, question_id: question }
  #       expect(response).to redirect_to question_path(question)
  #     end
  #   end
  #
  #   context 'without sign in' do
  #     it 'deletes the answer' do
  #       expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
  #     end
  #
  #     it 'render parent question' do
  #       delete :destroy, params: { id: answer, question_id: question }
  #       expect(response).to render_template 'questions/show'
  #     end
  #   end
  # end
end
