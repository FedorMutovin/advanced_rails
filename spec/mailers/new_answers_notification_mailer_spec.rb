require 'rails_helper'

RSpec.describe NewAnswersNotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let(:mail_for_author) { described_class.send_notification(question.author, answer) }

  describe 'NewAnswerNotificationMailer#send_notification' do
    it 'renders the headers' do
      expect(mail_for_author.subject).to eq('New answer')
      expect(mail_for_author.to).to eq([question.author.email])
      expect(mail_for_author.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail_for_author.body.encoded).to match(answer.body)
    end
  end
end
