require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, :with_files, author: user) }

    context 'if user is author' do
      before { sign_in(user) }

      it 'deletes the question file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        expect(response).to render_template :destroy
      end
    end

    context 'if user is not author' do
      before { sign_in(other_user) }

      it 'is not deletes the question file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        expect(response).to render_template :destroy
      end

    end
  end
end
