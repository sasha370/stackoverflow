Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  resources :questions do
    member do
      post :thumb_up
      post :cancel_voice
      post :thumb_down
    end
    resources :answers, shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end
end
