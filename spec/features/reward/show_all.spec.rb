require 'rails_helper'

describe 'User can show all of his rewards for the answers', "
 To show all my rewards for the answers
 As an authenticated
 I'd like to be able to view my rewards
" do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, best: true, question: question, author: user }
  let!(:reward) { create :reward, answer: answer, question: question }

  it 'Author view all rewards' do
    sign_in(user)
    click_on 'My rewards'

    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='#{reward.image.filename}']")
  end

  it 'Other user view all rewards of author' do
    sign_in(other_user)
    visit rewards_path

    expect(page).not_to have_content reward.question.title
    expect(page).not_to have_content reward.name
    expect(page).not_to have_css("img[src*='#{reward.image.filename}']")
  end
end
