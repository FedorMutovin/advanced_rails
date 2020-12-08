require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it 'calls Reputation#calculate' do
    expect(Reputation).to receive(:calculate).with(question)
    described_class.perform_now(question)
  end
end
