require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #search' do
    # let!(:search) { {"query" => "test search", "options" => "all"} }
    let!(:question) { create(:question, title: 'First question') }

    it 'assigns the requested search to @search' do
      get :search, params: {query: 'test search', options: 'All'}
      expect(assigns(:search)).to eq( "query"=>"test search", "options"=>"All")
    end

    it 'assigns the requested klass_name to @klass_name ' do
      get :search, params: {query: 'test search', options: 'Question'}
      expect(assigns(:klass_name)).to eq Question
    end

    it 'assigns the requested ThinkingSphinx to @klass_name if All' do
      get :search, params: {query: 'test search', options: 'All'}
      expect(assigns(:klass_name)).to eq ThinkingSphinx
    end

    it 'the search engine responds for ALL query' do
      allow(ThinkingSphinx).to receive(:search).with("test search")
      get :search, params: {query: 'test search', options: 'All'}
    end

    it 'the search engine responds for ALL  query and return data' do
      allow(ThinkingSphinx).to receive(:search).with("First").and_return(question)
      get :search, params: {query: 'First', options: 'All'}
    end

    # it 'the search engine responds to the request by Class and returns it instance' do
    #   get :search, params: {query: 'First', options: 'Question'}
    #   expect(assigns(:results)).to be_instance_of Question
    # end

    it 'redirect to root if query is empty' do
      get :search, params: {query: ''}
      expect(response).to redirect_to root_path
    end

    it 'render to Search if query is not empty' do
      get :search, params: {query: 'test', options: 'All'}
      expect(response).to render_template :search
    end

    # it 'call SearchService' do
    #   # get :search, params: {query: 'test', options: 'all'}
    #   # expect(response).to render_template :search
    # end
  end
end
