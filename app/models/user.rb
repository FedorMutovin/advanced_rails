class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :rewards, through: :answers
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author?(resource)
    id.eql?(resource.author_id)
  end
end
