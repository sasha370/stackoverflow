require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:rewards) }
  it { should have_many(:ratings) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe 'author?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:another_user) { create(:user) }

    it 'already add voice for resource' do
      question.vote_plus(user)
      expect(user.voted?(question)).to eq true
    end
  end
end
