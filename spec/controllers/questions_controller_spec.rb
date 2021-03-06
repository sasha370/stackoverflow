require 'rails_helper'
require_relative './concerns/ratinged'
require_relative './concerns/commented'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:reward) { create(:reward, question: question) }

  it_behaves_like 'ratinged' do
    let!(:another_user) { create(:user) }
    let(:user) { create(:user) }
    let(:ratinged) { create(:question, user: another_user) }
  end

  it_behaves_like 'commented' do
    let!(:user) { create(:user) }
    let(:commented) { create(:question, user: user) }
    let(:another_user) { create(:user) }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }

    it 'populate an array of all questions' do
      questions << question
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new links for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'assigns new comment for question' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns the requested link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question on the database' do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end

      it 'render show view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: {id: question, question: {title: 'TitleTest', body: 'BodyTest'}}
        question.reload

        expect(question.title).to eq 'TitleTest'
        expect(question.body).to eq 'BodyTest'
      end

      it 'redirect to updated question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: question, question: attributes_for(:question, :invalid)} }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'redirect to question' do
        expect(response).to render_template :edit
      end
    end

    context 'NOT Author of question' do
      before { login(another_user) }

      it 'does not change question attributes' do
        patch :update, params: {id: question, question: {title: 'TitleTest_another', body: 'BodyTest_another'}}
        question.reload
        expect(question.title).to_not eq 'TitleTest_another'
        expect(question.body).to_not eq 'BodyTest_another'
      end

      it 'redirect to question' do
        patch :update, params: {id: question, question: {title: 'TitleTest_another', body: 'BodyTest_another'}}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    before { login(question.user) }

    it 'delete the question' do
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end

    context 'NOT Author of question' do
      before { login(another_user) }
      it 'can`t delete' do
        expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(0)
      end

      it 'redirect to question' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #subscribe' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    before { login(user) }

    it 'assigns the requested question to @question' do
      get :subscribe, params: {id: question.id}, xhr: :js
      expect(assigns(:question)).to eq(question)
    end

    it 'should create new Subscription for user' do
      expect { get :subscribe, params: {id: question.id}, xhr: :js }.to change(Subscription, :count).by(1)
    end

    it 'should notify user' do
      get :subscribe, params: {id: question.id}, xhr: :js
      expect(response).to render_template :subscribe
    end

    context 'if user already subscribed' do
      let!(:subscription) { question.subscriptions.create(user: user) }

      it 'should unsubscribe ' do
        expect { get :subscribe, params: {id: question.id}, xhr: :js }.to change(Subscription, :count).by(-1)
      end

      it 'should notify user ' do
        get :subscribe, params: {id: question.id}, xhr: :js
        expect(response).to render_template :subscribe
      end
    end
  end
end
