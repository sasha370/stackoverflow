require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer on the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'render to associate question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does noe save on the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render to associate question view with create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    context 'with valid attributes' do
      it 'changes answers attributes' do
        patch :update, params: { id: answer, answer: { body: "Updated body" } }, format: :js
        answer.reload
        expect(answer.body).to eq('Updated body')
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: "Updated body" } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes'
    it 'do not change answer attributes' do
      expect do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      end.to_not change(answer, :body)
    end

    it 'render update view' do
      patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    before { login(user) }

    it 'delete the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'response have "No content" status' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to have_http_status(204)
    end
  end

  describe "PUT #choose_best" do

    it 'assign answer to @answer' do
      put :choose_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq(answer)
    end

    it 'author can choose best answer' do
      put :choose_best, params: { id: answer }, format: :js
      answer.reload
      expect(answer).to be_best
    end
  end
end
