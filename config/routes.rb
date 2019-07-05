Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users
  resources :reviews, except: [:show]
  namespace :admin do
    require 'sidekiq/web'
    authenticate :user, ->(u) { u.id == 1 } do
      mount Sidekiq::Web => '/sidekiq'
    end
    get 'statistics', 'explore', controller: 'pages'

    resources :forums, except: %i[new edit]
    resources :posts, except: %i[new edit] do
      get :clusters, on: :member
      get :visualization, on: :member
      post :segment, on: :member
      post :sentiment_analysis, on: :member
      post :compute_embedding, on: :member
    end
    resources :reviews, only: %i[index destroy]
    resources :users, only: %i[index destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
