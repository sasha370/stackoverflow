class Question < ApplicationRecord
  include Ratingable
  include Commentable
  include Linkable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5 }
end
