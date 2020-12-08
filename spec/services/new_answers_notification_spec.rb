require 'rails_helper'
RSpec.describe NewAnswersNotification do
  subject(:new_answers_notification) { described_class.new }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it 'sends email to question owner' do
    expect(NewAnswersNotificationMailer).to receive(:send_notification).with(question.author, answer).and_call_original
    new_answers_notification.send_notification(question.author, answer)
  end
end
