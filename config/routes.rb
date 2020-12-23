Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :attachments, only: :destroy

  resources :questions do
    resources :answers, shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end
end
