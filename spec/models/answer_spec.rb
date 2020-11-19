require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'commentable'

  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :author }
  it { is_expected.to have_one(:reward).dependent(:nullify) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
end
