require 'rails_helper'
require_relative './shared/api_authorization'

describe 'Profiles API', type: :request do

  let(:headers) { {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json'} }
  let(:user) { create(:user) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method_name) { :get }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    before { do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers) }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      %w[id email admin created_at updated_at].each do |attr|
        expect(json['user'][attr]).to eq user.send(attr).as_json
      end
    end

    it 'does not returns private fields' do
      %w[password encrypted_password].each do |attr|
        expect(json).to_not have_key(attr)
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method_name) { :get }
    let!(:users) { create_list(:user, 3) }
    let(:user_response) { json['users'].first }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable'

    before { do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers) }

    it 'return 200 status' do
      expect(response).to be_successful
    end

    it 'users list do not contains Current_user' do
      json['users'].each do |item|
        expect(item['id']).to_not eq user.id
      end
    end

    it 'return users list' do
      expect(json['users'].size).to eq 3
    end

    it 'returns public fields' do
      %w[id email created_at updated_at].each do |attr|
        expect(user_response[attr]).to eq users.first.send(attr).as_json
      end
    end

    it 'does not returns private fields' do
      %w[password admin encrypted_password].each do |attr|
        expect(user_response).to_not have_key(attr)
      end
    end
  end
end
