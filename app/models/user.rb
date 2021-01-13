class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :ratings

  def author?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    resource.ratings.exists?(user_id: id)
  end

  def self.find_for_oauth(data)

  end
end
