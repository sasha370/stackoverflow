class Question < ApplicationRecord
  has_many :answers

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5 }
end
