Rails.application.routes.draw do
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :milongas, only: [:index, :show]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
