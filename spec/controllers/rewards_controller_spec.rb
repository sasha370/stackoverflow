require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:reward) { question.create_reward(title: 'For smt', image: create_file_blob) }
  let!(:answer) { create(:answer, question: question, user: user, best: true) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:rewards)).to match_array user.rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
