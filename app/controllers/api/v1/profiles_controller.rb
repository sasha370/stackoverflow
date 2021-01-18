class Api::V1::ProfilesController < ActionController::Base
  before_action :doorkeeper_authorize!

  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
