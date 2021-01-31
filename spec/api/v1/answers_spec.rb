require 'rails_helper'
require_relative './shared/api_authorization'
require_relative './shared/api_destroy'
require_relative './shared/api_update'
require_relative './shared/api_content_list'

describe 'Answer API', type: :request do

  let(:headers) { {'ACCEPT' => 'application/json'} }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer_response) { json['answers'].first }
    let(:attributes) { %w[id body created_at user_id question_id] }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method_name) { :get }

    it_behaves_like 'API Authorizable'
    before { do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers) }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'return list of answers' do
      expect(json['answers'].size).to eq answers.count
    end

    it 'returns public fields' do
      attributes.each do |attr|
        expect(answer_response[attr]).to eq answers.first.send(attr).as_json
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:resource) { create(:answer, :with_file, question: question) }
    let!(:comments) { create_list(:comment, 3, commentable_type: 'Answer', commentable_id: resource.id) }

    let(:api_path) { "/api/v1/answers/#{resource.id}" }
    let(:method_name) { :get }
    let(:resource_name) { 'answer' }
    let(:public_fields) { %w[id body created_at question_id best] }
    let(:content_types) { %w[links files comments] }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Listable'
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method_name) { :post }

    let(:model) { Answer }
    let!(:question) { create(:question) }
    let(:resource) { 'answer' }
    let(:resource_attr_incorrect) { {body: ''} }
    let(:attributes) { %w[body] }
    let(:resource_attr) { attributes_for(resource.to_sym) }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Updatable'

    it 'save resource in DB' do
      expect { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }.to change(model, :count).by(1)
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:another_answer) { create(:answer, question: question) }
    let(:another_api_path) { "/api/v1/answers/#{another_answer.id}" }
    let(:method_name) { :patch }

    let(:model) { Answer }
    let(:resource) { 'answer' }
    let(:resource_attr) { {body: 'New Body'} }
    let(:resource_attr_incorrect) { {body: ''} }
    let(:attributes) { %w[body] }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Updatable'
    it_behaves_like 'API NOT Updatable with another_user'

    it 'don`t change resource count in DB' do
      expect { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }.to_not change(model, :count)
    end
  end

  describe 'DESTROY /api/v1/answers/:id' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:another_answer) { create(:answer, question: question) }
    let(:another_api_path) { "/api/v1/answers/#{another_answer.id}" }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method_name) { :delete }

    let!(:model) { Answer }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Destroyable'
  end
end
