require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  shared_examples_for 'providers' do |provider|
    describe '#{provider} test' do

      let(:oauth_data) { {
          'provider' => provider,
          'uid' => '123545',
          'info' => {
              'email' => 'test@test.ru',
          }} }
      let(:oauth_data_without_email) { {
          'provider' => provider,
          'uid' => '123545'
          } }

      context 'when user exist' do
        let!(:user) { create(:user, email: 'test@test.ru') }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          get provider.to_sym
        end

        it 'login user if it exist' do
          expect(subject.current_user).to eq user
        end
        #
        it 'redirect to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          get provider.to_sym
        end

        it 'redirect to root path if user does not exist' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist and responce don`t have Email' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
          get provider.to_sym
        end

        it 'redirect to get_email_path' do
          expect(response).to redirect_to get_email_url
        end
      end
    end
  end

  describe 'Github' do
    it_should_behave_like 'providers', 'github'
  end

  describe 'GoogleAuth' do
    it_should_behave_like 'providers', 'google_oauth2'
  end

  describe 'VKontakte' do
    it_should_behave_like 'providers', 'vkontakte'
  end
end
