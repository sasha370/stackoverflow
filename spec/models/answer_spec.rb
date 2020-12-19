require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }
  it { should belong_to(:question) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

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
end
