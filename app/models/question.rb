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
  validates :title, :body, length: {minimum: 5}
  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
