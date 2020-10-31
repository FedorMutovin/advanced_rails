class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :nullify

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :best, -> { order best: :desc }
  scope :with_reward, -> { where(best: true) }

  def mark_best
    question.answers.update_all(best: false)
    update(best: true)
    self.reward = question.reward if question.reward.present?
  end
end
