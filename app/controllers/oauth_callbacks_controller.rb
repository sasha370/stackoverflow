class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authenticate
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    else
      redirect_to root_path, alert: 'SMT went wrong'
    end
  end

  def google_oauth2
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authenticate
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      redirect_to root_path, alert: 'SMT went wrong'
    end
  end
end
