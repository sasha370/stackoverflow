class Question < ApplicationRecord
  has_many :answers
  # belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5 }
end
