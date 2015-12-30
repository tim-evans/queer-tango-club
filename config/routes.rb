Rails.application.routes.draw do
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :events, only: [:show] do
    member do
      get 'choose'
      post 'add_to_cart'
      get 'checkout'
      post 'purchase'
      get 'receipt'
    end
  end

  resources :milongas, only: [:index]
  resources :workshops, only: [:index]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
