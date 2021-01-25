class SearchesController < ApplicationController
  before_action :search_params, only: [:search]
  SEARCH_TYPES = %w[All Question Answer Comment User]

  def search
    if SEARCH_TYPES.include?(@search[:options])
      @klass_name = @search[:options] == 'All' ? ThinkingSphinx : @search[:options].constantize
      @results = @klass_name.search @search[:query]
    else
      redirect_to root_path, alert: 'Search can`t be blanc'
    end
  end

  private

  def search_params
    @search = params.permit(:query, :options, :commit)
  end
end
