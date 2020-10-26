Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[new create destroy update] do
      post :mark_best, on: :member
    end
  end

  root to: 'questions#index'
  resources :files, only: :destroy
end
