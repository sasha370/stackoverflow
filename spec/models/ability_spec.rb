require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :get_email, User }
    it { should be_able_to :set_email, User }
    it { should be_able_to :search, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: another_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, another_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, another_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, another_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, another_answer }

    it { should be_able_to :choose_best, another_answer }

    context 'add comments' do
      it { should be_able_to :add_comment, question }
      it { should be_able_to :add_comment, answer }
    end

    context 'delete comments' do
      let(:comment) { create(:comment, commentable: question, user: user) }
      let(:other_comment) { create(:comment, commentable: question, user: another_user) }

      it { should be_able_to :destroy_comment, comment }
      it { should_not be_able_to :destroy_comment, other_comment }
    end

    it { should be_able_to :vote, another_question }
    it { should_not be_able_to :vote, question }

    it { should be_able_to :vote, another_answer }
    it { should_not be_able_to :vote, answer }

    it { should be_able_to :index, Reward }

    let(:question_with_attach) { create :question, :with_file , user: user}

    context 'remove attachment' do
      it { should be_able_to :destroy, question_with_attach.files.first, record: question_with_attach }
    end
  end
end
