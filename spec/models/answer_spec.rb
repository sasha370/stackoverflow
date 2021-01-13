require 'rails_helper'
require_relative './concerns/ratingable_spec'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

  it_behaves_like 'ratingable' do
    let!(:another_user) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: another_user) }
    let(:model) { create(:answer, question: question, user: another_user) }
  end


  describe '#set_best' do
    it 'the answer set as best' do
      answer.set_best
      expect(answer).to be_best
    end

    it 'set another answer as best' do
      answer.set_best
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end

  describe '#sort_by_best' do
    it 'orders the best answer is the first' do
      expect(best_answer).to eq question.answers[0]
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
