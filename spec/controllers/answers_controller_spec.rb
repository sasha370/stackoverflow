require 'rails_helper'
require_relative './concerns/ratinged'
require_relative './concerns/commented'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'ratinged' do
    let!(:another_user) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: another_user) }
    let(:ratinged) { create(:answer, question: question, user: another_user) }
  end

  it_behaves_like 'commented' do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user: another_user) }
    let(:commented) { create(:answer, question: question, user: another_user) }
  end

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
    before { login(user) }
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

    context 'NOT author ' do
      before { login(another_user) }
      it 'can`t change attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author ' do
      before { login(user) }
      it 'delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'response have "No content" status' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to have_http_status(204)
      end
    end

    context 'NOT Author' do
      before { login(another_user) }
      it 'can`t delete answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(0)
      end
    end
  end

  describe "PUT #choose_best" do
    before { login(user) }
    it 'assign answer to @answer' do
      put :choose_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq(answer)
    end

    it 'author can choose best answer' do
      put :choose_best, params: { id: answer }, format: :js
      answer.reload
      expect(answer).to be_best
    end

    context 'NOT Author of question' do
      it 'can`t choose best answer' do
        login(another_user)
        put :choose_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end
