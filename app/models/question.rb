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

  def vote_plus(user)
    ratings.find_or_create_by(user_id: user.id).update(vote: 1)
  end

  def vote_minus(user)
    ratings.find_or_create_by(user_id: user.id).update(vote: -1)
  end

  def cancel_voice(user)
    ratings.find_by(user_id: user.id).destroy
  end

  def name_id
    self.class.name.downcase + '_' + id.to_s
  end
end
