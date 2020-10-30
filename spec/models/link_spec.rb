require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name  }
  it { should validate_presence_of :url }
  it { is_expected.to validate_url_of(:url) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:google_link) { create(:google_link, linkable: question) }
  let(:gist_link) { create(:gist_link, linkable: question) }

  context 'is gist?' do
    it 'true' do
      expect(gist_link).to be_gist
    end
    it "false" do
      expect(google_link).not_to be_gist
    end
  end

  context 'give gist content?' do
    it 'true' do
      expect(gist_link.gist).to eq "World"
    end
    it "false" do
      expect(google_link.gist).to eq nil
    end
  end
end
