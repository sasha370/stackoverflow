class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :ratings, dependent: :destroy, as: :ratingable
  belongs_to :user
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5 }

  def rating
    ratings.pluck(:vote).sum
  end

  def vote_plus
    ratings.create_with(vote: 1).find_or_create_by(user_id: user_id)
  end
end
