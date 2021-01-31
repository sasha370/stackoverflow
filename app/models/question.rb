class Question < ApplicationRecord
  include Ratingable
  include Commentable
  include Linkable

  has_many :answers, dependent: :destroy
  belongs_to :user, touch: true
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
  validates :title, :body, length: {minimum: 5}

  scope :created_in_last_day, -> { where('created_at >= ?' , 1.day.ago) }
end
