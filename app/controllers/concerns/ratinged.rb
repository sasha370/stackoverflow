module Ratinged
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :resource_set, only: [:thumb_up, :thumb_down, :cancel_voice]
  end

  def thumb_up
      @ratinged.vote_plus(current_user)
      json_template
  end

  def thumb_down
      @ratinged.vote_minus(current_user)
      json_template
  end

  def cancel_voice
      @ratinged.cancel_voice(current_user)
      json_template
  end

  private

  def json_template
    render json: { rating: @ratinged.rating, type: @ratinged.name_id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def resource_set
    @ratinged = model_klass.find(params[:id])
  end

end
