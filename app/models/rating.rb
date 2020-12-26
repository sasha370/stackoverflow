class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true
  belongs_to :user
end
