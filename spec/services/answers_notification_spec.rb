require 'rails_helper'
RSpec.describe NewAnswersNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it 'sends email to question owner' do
    expect(NewAnswersNotificationMailer).to receive(:send_notification).with(question.author, answer).and_call_original
    subject.send_notification(question.author, answer)
  end
end
