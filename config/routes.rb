Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"


  resources :questions do
    member { delete :delete_attachment }
    resources :answers, shallow: true, only: [:create, :edit, :destroy, :update] do
      member do
        put :choose_best
      end
    end
  end

end
