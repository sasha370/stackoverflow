class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable,
         omniauth_providers: [:github, :google_oauth2, :vkontakte]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :ratings
  has_many :authorizations, dependent: :destroy

  def voted?(resource)
    resource.ratings.exists?(user_id: id)
  end
end
