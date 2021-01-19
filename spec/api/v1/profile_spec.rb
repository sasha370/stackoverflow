require 'rails_helper'
require_relative './shared/api_authorization'

describe 'Profiles API', type: :request do

  let(:headers) { {'CONTENT_TYPE' => 'application/json',
                   'ACCEPT' => 'application/json'} }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method_name) { :get }

    it_behaves_like 'API Authorizer'


    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method_name) { :get }

    it_behaves_like 'API Authorizer'

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:user_response) { json['users'].first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'users list do not contains Current_user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it 'return users list' do
        expect(json['users'].size).to eq 3
      end

      it 'returns public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
