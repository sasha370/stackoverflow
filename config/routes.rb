Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"


  resources :questions do
    resources :answers,shallow: true, only: [:create, :edit, :destroy, :update]
  end

end
