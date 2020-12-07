require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { described_class.digest(user) }
    let!(:questions) { create_list(:question, 2, created_at: Time.now, author: user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
