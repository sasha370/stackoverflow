class SearchesController < ApplicationController
  before_action :search_params, only: [:search]


  def search
    redirect_to root_path, alert: 'Search can`t be blanc' if params[:query].blank?
    if @search[:options] == 'all'
      @results = ThinkingSphinx.search @search[:query]
    else
      @results = klass_name.search @search[:query]
    end
  end

  private

  def klass_name
    @search[:options].capitalize.constantize
  end

  def search_params
    @search = params.permit(:query, :options, :commit)
  end
end
