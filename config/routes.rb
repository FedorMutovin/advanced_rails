require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    post 'set_email', to: 'oauth_callbacks#set_email'
  end
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

  resources :questions, concerns: %i[voteable commentable] do
    resources :answers, concerns: %i[voteable commentable], shallow: true, only: %i[new create destroy update] do
      post :mark_best, on: :member
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
