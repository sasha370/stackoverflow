require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #search' do

    it 'redirect to search_result if query is empty' do
      get :search, params: {query: ''}
      expect(response).to redirect_to root_path
    end

    it 'redirect to search_result if query is not empty' do
      get :search, params: {query: 'test', options: 'all'}
      expect(response).to render_template :search
    end
  end
end
