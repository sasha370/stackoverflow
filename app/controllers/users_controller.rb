class UsersController < ApplicationController

  def get_email
    @user = User.new
  end

  def set_email
    password = Devise.friendly_token[0, 20]
    user = User.create!(
        email: email_params[:email],
        password: password,
        password_confirmation: password
    )
    user.create_authorization({provider: session[:auth]['provider'], uid: session[:auth]['uid']})
    redirect_to root_path, alert: 'Account create! Please confirm your Email!'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
