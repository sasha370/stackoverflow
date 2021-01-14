require 'rails_helper'

RSpec.describe FindForOauthService do

  let!(:user) { create(:user, email: 'jackson.keeling@example.com') }
  let(:auth) { Faker::Omniauth.github }

  subject {FindForOauthService.new(auth)}

  context 'user already has authorization' do
    it 'returns the user' do
      user.authorizations.create(provider: auth[:provider], uid: auth[:uid])
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    context 'user already exist' do
      let!(:auth) { Faker::Omniauth.github }
      let!(:user) { create(:user, email: auth[:info][:email]) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'created authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count)
      end

      it ' create authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq(auth[:provider])
        expect(authorization.uid).to eq(auth[:uid])
      end

      it 'returns user' do
        expect(subject.call).to eq user
      end
    end
  end

  context 'user does not exist' do
    let!(:auth) { Faker::Omniauth.github }

    it 'creates new user' do
      expect { subject.call }.to change(User, :count).by 1
    end

    it 'returns new user' do
      expect(subject.call).to be_a(User)
    end

    it 'fills user email' do
      user = subject.call
      expect(user.email).to eq auth[:info][:email]
    end

    it 'create authorization for user' do
      user = subject.call
      expect(user.authorizations).to_not be_empty
    end

    it 'create authorization for user with correct uid and provider' do
      authorization = subject.call.authorizations.first

      expect(authorization.provider).to eq(auth[:provider])
      expect(authorization.uid).to eq(auth[:uid])
    end
  end
end
