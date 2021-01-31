class Comment < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, :user, presence: true
end
