class Authorization < ApplicationRecord
  belongs_to :user, touch: true
  validates :provider, :uid, presence: true
end
