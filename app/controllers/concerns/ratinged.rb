module Ratinged
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: [:thumb_up, :thumb_down, :cancel_voice]
  end

  def thumb_up
    unless current_user.author?(@ratinged)
      @ratinged.vote_plus(current_user)
      json_template
    end
  end

  def thumb_down
    unless current_user.author?(@ratinged)
      @ratinged.vote_minus(current_user)
      json_template
    end
  end

  def cancel_voice
    unless current_user.author?(@ratinged)
      @ratinged.cancel_voice(current_user)
      json_template
    end
  end

  private

  def json_template
    render json: { rating: @ratinged.rating, type: @ratinged.name_id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_resource
    @ratinged = model_klass.find(params[:id])
  end
end
