module Ratingable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, dependent: :destroy, as: :ratingable
  end

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
