require 'rails_helper'
require_relative './shared/api_authorization'
require_relative './shared/api_destroy'
require_relative './shared/api_update'

describe 'Questions API', type: :request do

  let(:headers) { {'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizer' do
      let(:method_name) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns public fields' do
        %w[id body created_at updated_at user_id question_id].each do |attr|
          expect(answer_response[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_file, question: question) }
    let!(:comments) { create_list(:comment, 3, commentable_type: 'Answer', commentable_id: answer.id) }
    let(:answer_response) { json['answer'] }
    let(:method_name) { :get }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizer'


    let(:access_token) { create(:access_token) }

    before { get api_path, params: {access_token: access_token.token}, headers: headers }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'return answer' do
      expect(['answer'].size).to eq 1
    end

    it 'returns public fields' do
      %w[id body created_at updated_at question_id best].each do |attr|
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end

    it 'contains user object' do
      expect(answer_response['user']['id']).to eq answer.user.id
    end

    it 'contains list of links' do
      expect(answer_response['links'].size).to eq answer.links.count
      expect(answer_response['links'].first['id']).to eq answer.links.first.id
    end

    it 'contains list of attachments' do
      expect(answer_response['files'].size).to eq answer.files.count
      expect(answer_response['files'].first['id']).to eq answer.files.first.id
    end

    it 'contains list of comments' do
      expect(answer_response['comments'].size).to eq answer.comments.count
      expect(answer_response['comments'].first['id']).to eq answer.comments.first.id
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:question) { create(:question) }
    let(:method_name) { :post }
    let(:resource) { 'answer' }
    let(:resource_attr_incorrect) { {body: ''} }
    let(:resource_response) { json[resource] }
    let(:model) { Answer }
    let(:attributes) { %w[body] }
    let(:resource_attr) { attributes_for(resource.to_sym) }

    it_behaves_like 'API Authorizer'
    it_behaves_like 'API Updatable'

    it 'save resource in DB' do
      expect { do_request(method_name, api_path, params: {resource => resource_attr, access_token: access_token.token}, headers: headers) }.to change(model, :count).by(1)
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:method_name) { :patch }
    let(:resource) { 'answer' }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:model) { Answer }
    let(:resource_attr) { {body: 'New Body'} }
    let(:resource_response) { json[resource] }
    let(:resource_attr_incorrect) { {body: ''} }
    let(:attributes) { %w[body] }

    it_behaves_like 'API Authorizer'
    it_behaves_like 'API Updatable'
  end

  describe 'DESTROY /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:model) { Answer }
    let(:method_name) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizer'
    it_behaves_like 'API Destroyable'
  end
end

