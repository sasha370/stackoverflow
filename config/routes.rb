Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  concern :ratingable do
    member do
      post :thumb_up
      post :cancel_voice
      post :thumb_down
    end
  end

  concern :commentable  do
    member do
      post :add_comment
      delete :destroy_comment
    end
  end

  resources :questions, concerns: [:ratingable, :commentable] do
       resources :answers,  concerns: [:ratingable, :commentable], shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
