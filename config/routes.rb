Rails.application.routes.draw do
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :events, only: [:show, :new, :edit] do
    member do
      get 'cart'
    end
  end
  resources :milongas, only: [:index]
  resources :workshops, only: [:index]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
