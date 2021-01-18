class Api::V1::ProfilesController < Api::V1::BaseController
  # skip_load_and_authorize_resource
  # authorize_resource class: User

  def me
    authorize! :me_api_v1_profiles, current_resource_owner
    render json: current_resource_owner
  end

  def index
    authorize! :api_v1_profiles, current_resource_owner
    @users = User.where.not('id = ?', current_resource_owner.id)
    render json: @users
  end
end
