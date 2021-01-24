require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #search' do
    let!(:query) { {"query"=>"test search", "options"=>"all"} }

    it 'assigns the requested query to @query' do
      get :search, params: { query: 'test search', options: 'all'  }
      expect(assigns(:query)).to eq query
    end

    it 'assigns the requested query to @query' do
      get :search, params: { query: 'test search', options: 'question'  }
      expect(assigns(:klass_name)).to eq Question
    end

    it 'redirect to root if query is empty' do
      get :search, params: {query: ''}
      expect(response).to redirect_to root_path
    end

    it 'render to Search if query is not empty' do
      get :search, params: {query: 'test', options: 'all'}
      expect(response).to render_template :search
    end

    # it 'call SearchService' do
    #   # get :search, params: {query: 'test', options: 'all'}
    #   # expect(response).to render_template :search
    # end
  end
end
