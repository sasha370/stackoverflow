class Reward < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user, optional: true, touch: true
  validates :title, :image,  presence: true

  has_one_attached :image
end
