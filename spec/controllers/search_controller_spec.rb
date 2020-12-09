require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'returns 200 status code' do
      get :search, params: { search_text: 'some text', search_object: 'All' }, format: :js
      expect(response).to be_successful
    end

    %w[All Questions Answers Comments Users].each do |search_object|
      it "calls search for #{search_object}" do
        expect(SphinxSearch).to receive(:search_results).with('some text', search_object)
        get :search, params: { search_text: 'some text', search_object: search_object }, format: :js
      end
    end

    it 'renders index template' do
      get :search, params: { search_text: 'some text', search_object: 'All' }, format: :js
      expect(response).to render_template :search
    end
  end
end
