class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :ratings
  has_many :authorizations, dependent: :destroy

  def author?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    resource.ratings.exists?(user_id: id)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth[:provider], uid: auth[:uid].to_s)
  end
end
