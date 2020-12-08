require 'rails_helper'

RSpec.describe NewAnswersNotificationJob, type: :job do
  let(:service) { double('NewAnswersNotification') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  it 'calls NewAnswersNotification#send_notification(answer)' do
    allow(NewAnswersNotification).to receive(:new).and_return(service)
    expect(service).to receive(:send_notification).with(question.author, answer)
    described_class.perform_now(question.author, answer)
  end
end
