require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => 'sidekiq'
  end

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  devise_for :users, controllers: {omniauth_callbacks: 'oauth_callbacks'}

  get '/user/get_email', to: 'users#get_email', as: 'get_email'
  post '/user/set_email', to: 'users#set_email', as: 'set_email'
  get '/search', to: "searches#search"

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  concern :ratingable do
    member do
      post :thumb_up
      post :cancel_voice
      post :thumb_down
    end
  end

  concern :commentable do
    member do
      post :add_comment
      delete :destroy_comment
    end
  end

  resources :questions, concerns: [:ratingable, :commentable] do
    member {get :subscribe}
    resources :answers, concerns: [:ratingable, :commentable], shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end

  mount ActionCable.server => '/cable'
  root to: "questions#index"
end
