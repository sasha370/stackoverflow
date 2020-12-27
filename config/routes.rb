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

  resources :questions, concerns: [:ratingable] do
    resources :answers, shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end
end
