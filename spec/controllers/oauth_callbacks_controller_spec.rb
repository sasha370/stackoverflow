require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  shared_examples_for 'providers' do |provider|
    describe '#{provider} test' do
      let(:oauth_data) { {'provider' => provider, 'uid' => '123'} }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider.to_sym
      end

      context 'when user exist' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider.to_sym
        end

        it 'login user if it exist' do
          expect(subject.current_user).to eq user
        end

        it 'redirect to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth)
          get provider.to_sym
        end

        it 'redirect to root path if user does not exist' do
          expect(response).to redirect_to root_path
        end

        it 'does not login user if it does not exist' do
          expect(subject.current_user).to_not be
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
