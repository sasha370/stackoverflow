class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 5 }
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def set_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
      question.reward&.update!(user_id: user_id)
    end
  end
end
