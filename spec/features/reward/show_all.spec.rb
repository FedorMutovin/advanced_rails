require 'rails_helper'

feature 'User can show all of his rewards for the answers', %q{
 To show all my rewards for the answers
 As an authenticated
 I'd like to be able to view my rewards
} do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given(:question) { create :question, author: user }
  given(:answer) { create :answer, best: true, question: question, author: user }
  given!(:reward) { create :reward, answer: answer, question: question}

  scenario 'Author view all rewards' do
    sign_in(user)
    click_on 'My rewards'

    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='#{reward.image.filename.to_s}']")
  end

  scenario 'Other user view all rewards of author' do
    sign_in(other_user)
    visit rewards_path

    expect(page).to_not have_content reward.question.title
    expect(page).to_not have_content reward.name
    expect(page).to_not have_css("img[src*='#{reward.image.filename.to_s}']")
  end
end
