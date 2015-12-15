Rails.application.routes.draw do
  resources :packages
  resources :events
  resources :members
  resources :attendees

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end

  get '/about' => 'about#index'

  root to: 'home#index'
end
