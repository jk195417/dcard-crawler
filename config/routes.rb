Rails.application.routes.draw do
  devise_for :users

  namespace :scholar do
    get 'statistics', 'explore', controller: 'pages'
    resources :forums, only: %i[index show create update destroy]
    resources :posts, only: %i[index show create update destroy] do
      get :clusters, on: :member
      get :visualization, on: :member
      post :segment, on: :member
      post :sentiment_analysis, on: :member
      post :compute_embedding, on: :member
    end
  end

  namespace :admin do
    require 'sidekiq/web'
    authenticate :user, ->(user) { user.is_admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :users, only: %i[index update destroy]
  end

  root to: 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
