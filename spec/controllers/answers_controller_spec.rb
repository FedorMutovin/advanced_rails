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
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
      it 'redirects to parent question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { sign_in(user) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), author: user } }.to_not change(Answer, :count)
      end
      it 're-renders parent question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end

    end

    context 'without sign in' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), author: user } }.to_not change(Answer, :count)
      end

      it 're-renders parent question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), author: user }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do

    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with sign in' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'without sign in' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 'render parent question' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
