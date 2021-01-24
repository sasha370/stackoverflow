class SearchesController < ApplicationController

  def search
    puts params
    @query = params.permit(:query, :options)

    if params[:query].blank?
      redirect_to root_path, alert: 'Can`t be blanc`'
    else

    end
  end

  private

  def search_params
    @query = params.permit(:query, :options)
  end
end
