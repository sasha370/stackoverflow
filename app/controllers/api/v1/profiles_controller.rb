class Api::V1::ProfilesController < Api::V1::BaseController
  # skip_load_and_authorize_resource
  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    @users = User.where.not('id = ?', current_resource_owner.id)
    render json: @users
  end
end
