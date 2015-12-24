Rails.application.routes.draw do
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :events, only: [:show]
  resources :milongas, only: [:index]
  resources :workshops, only: [:index]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
