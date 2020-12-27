require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:rewards) }
  it { should have_many(:ratings) }

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
end
