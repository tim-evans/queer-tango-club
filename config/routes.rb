Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :events, only: [:show] do
    member do
      get 'choose'
      post 'add_to_cart'
      get 'checkout'
      post 'purchase'
      get 'receipt'
      get 'members'
      get 'photos'
    end

    resources :privates, only: [:show]
  end

  resources :photos, only: [:create, :destroy]

  resources :milongas, only: [:index]
  resources :workshops, only: [:index]
  resources :locations, only: [:show]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
