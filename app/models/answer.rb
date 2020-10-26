class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  scope :best, -> { order best: :desc }

  def mark_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
