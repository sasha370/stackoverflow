class UsersController < ApplicationController

  def get_email
    @user = User.new
  end

  def set_email
    user = User.find_by(email: email_params[:email])

    if user
      user.confirmed_at = nil
      user.send_confirmation_instructions
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(
        email: email_params[:email],
        password: password,
        password_confirmation: password
      )
    end
    user.authorizations.create(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
    redirect_to root_path, alert: 'Account create! Please confirm your Email!'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
