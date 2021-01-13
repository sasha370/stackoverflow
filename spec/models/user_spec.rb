require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:rewards) }
  it { should have_many(:ratings) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe 'author?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:another_user) { create(:user) }

    it 'should be correct if user is author' do
      expect(user.author?(question)).to eq(true)
    end

    it 'shouldn`t not be correct if user are not author' do
      expect(another_user.author?(question)).to eq(false)
    end

    it 'already add voice for resource' do
      question.vote_plus(user)
      expect(user.voted?(question)).to eq true
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user, email: 'jackson.keeling@example.com') }
    let(:auth) { Faker::Omniauth.github }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: auth[:provider], uid: auth[:uid])
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let!(:auth) { Faker::Omniauth.github }
        let!(:user) { create(:user, email: auth[:info][:email]) }
        let(:service) { double('FindForOauthService') }

        it 'calls FindForOauthService' do
          expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
          expect(service).to receive(:call)
          User.find_for_oauth(auth)
        end
      end
    end
  end
end
