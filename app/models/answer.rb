class Answer < ApplicationRecord
  include Ratingable
  include Commentable
  include Linkable

  belongs_to :question, touch: true
  belongs_to :user, touch: true

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 5 }

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  after_create :send_notifications

  def set_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
      question.reward&.update!(user_id: user_id)
    end
  end

  private

  def send_notifications
    NotificationJob.perform_later(self)
  end
end
