Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :voteable do
    member do
      post :vote_for
      post :vote_against
      delete :delete_vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:voteable, :commentable] do
    resources :answers, concerns: [:voteable, :commentable], shallow: true, only: %i[new create destroy update] do
      post :mark_best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
