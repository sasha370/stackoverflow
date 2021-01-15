require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }

    context 'delete comment' do
      let(:question) { create(:question, user: user) }
      let(:comment){create(:comment, commentable: question, user: user)}
      let(:other_comment){create(:comment, commentable: question, user: other_user)}

      it { should be_able_to :destroy_comment, comment}
      it { should_not be_able_to :destroy_comment, other_comment }
    end

    context 'add comment' do
      let(:question) { create(:question, user: user) }
      it { should be_able_to :add_comment, question }
    end

    it { should be_able_to :choose_best, another_answer }

    it { should be_able_to :index, Reward }

    it { should be_able_to :vote, another_question }
    it { should_not be_able_to :vote, question }

    it { should be_able_to :vote, another_answer }
    it { should_not be_able_to :vote, answer }
  end
end
