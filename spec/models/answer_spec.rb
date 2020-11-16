require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_one(:reward).dependent(:nullify) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
end
