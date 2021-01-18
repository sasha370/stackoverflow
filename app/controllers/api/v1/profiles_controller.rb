class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User


end
