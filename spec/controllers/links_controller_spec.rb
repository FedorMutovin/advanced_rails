require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, :with_files, author: user) }
    let!(:link) { create(:google_link, linkable: question) }

    context 'if user is author' do
      before { sign_in(user) }

      it 'deletes the question link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
        expect(response).to render_template :destroy
      end
    end

    context 'if user is not author' do
      before { sign_in(other_user) }

      it 'not deletes the question link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.not_to change(question.links, :count)
        expect(response).to redirect_to root_path
      end
    end
  end
end
