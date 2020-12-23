class Reward < ApplicationRecord
  belongs_to :question

  validates :title, :image,  presence: true

  has_one_attached :image
end
