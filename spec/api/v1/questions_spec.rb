require 'rails_helper'
require_relative './shared/api_authorization'
require_relative './shared/api_destroy'
require_relative './shared/api_update'
require_relative './shared/api_content_list'

describe 'Questions API', type: :request do

  let(:headers) { {'ACCEPT' => 'application/json'} }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 3) }
    let(:question) { questions.first }
    let(:question_response) { json['questions'].first }
    let(:attributes) { %w[id title body created_at updated_at user_id] }

    let(:api_path) { '/api/v1/questions' }
    let(:method_name) { :get }

    it_behaves_like 'API Authorizable'

    before { do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers) }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'return list of questions' do
      expect(json['questions'].size).to eq questions.count
    end

    it 'returns public fields' do
      attributes.each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
      end
    end

    it 'contains short title' do
      expect(question_response['short_title']).to eq question.title.truncate(7)
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:resource) { create(:question, :with_file) }
    let!(:answers) { create_list(:answer, 3, question: resource) }
    let!(:comments) { create_list(:comment, 3, commentable_type: 'Question', commentable_id: resource.id) }

    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:method_name) { :get }
    let(:resource_name) { 'question' }
    let(:public_fields) { %w[id title body created_at updated_at] }
    let(:content_types) { %w[answers links files comments] }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Listable'
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }
    let(:method_name) { :post }

    let(:model) { Question }
    let(:resource) { 'question' }
    let(:resource_attr_incorrect) { {title: '', body: ''} }
    let(:resource_attr) { attributes_for(resource.to_sym) }
    let(:attributes) { %w[title body] }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Updatable'

    it 'save resource in DB' do
      expect { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }.to change(model, :count).by(1)
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question, user: user) }
    let!(:another_question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:another_api_path) { "/api/v1/questions/#{another_question.id}" }
    let(:method_name) { :patch }

    let(:model) { Question }
    let(:resource) { 'question' }
    let(:resource_attr) { {title: 'New Title', body: 'New body'} }
    let(:resource_attr_incorrect) { {title: '', body: ''} }
    let(:attributes) { %w[title body] }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Updatable'
    it_behaves_like 'API NOT Updatable with another_user'

    it 'don`t change resource count in DB' do
      expect { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }.to_not change(model, :count)
    end

  end

  describe 'DESTROY /api/v1/questions/:id' do
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:another_question) { create(:question) }
    let(:another_api_path) { "/api/v1/questions/#{another_question.id}" }
    let(:method_name) { :delete }

    let!(:model) { Question }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Destroyable'
  end
end
