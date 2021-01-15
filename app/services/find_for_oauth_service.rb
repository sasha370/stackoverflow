class FindForOauthService

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: @auth['provider'], uid: @auth['uid'].to_s).first
    return authorization.user if authorization

    email = @auth.dig('info', 'email')
    user = User.where(email: email).first
    if user
      create_authorization(@auth, user)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email,
                         password: password,
                         password_confirmation: password,
                         confirmed_at: Time.now)
      create_authorization(@auth, user)
    end
    user
  end

  private

  def create_authorization(auth, user)
    user.authorizations.create(provider: auth['provider'], uid: auth['uid'].to_s)
  end
end

