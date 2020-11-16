Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voteable do
    member do
      post :vote_for
      post :vote_against
      delete :delete_vote
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], shallow: true, only: %i[new create destroy update] do
      post :mark_best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
