class SearchesController < ApplicationController
  before_action :search_params, only: [:search]

  def search
    redirect_to root_path, alert: 'Search can`t be blanc' if params[:query].blank?
    @klass_name = @search[:options] == 'All' ? ThinkingSphinx : @search[:options].constantize
    @results = @klass_name.search @search[:query]
  end

  private

  def search_params
    @search = params.permit(:query, :options, :commit)
  end
end
