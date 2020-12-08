class Answer < ApplicationRecord
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :nullify

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :send_notification

  scope :best, -> { order best: :desc }

  def mark_best
    question.answers.update_all(best: false)
    update(best: true)
    self.reward = question.reward if question.reward.present?
  end

  private

  def send_notification
    NewAnswersNotificationJob.perform_later(question.author, self)
  end
end
