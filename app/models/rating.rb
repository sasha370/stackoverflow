class Rating < ApplicationRecord
  belongs_to :ratingable, polymorphic: true, touch: true
  belongs_to :user, touch: true
end
