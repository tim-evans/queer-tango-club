Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  root to: 'home#index'
  get '/about' => 'about#index'

  resources :events, only: [:index, :show] do
    member do
      get 'choose'
      post 'add_to_cart'
      get 'checkout'
      post 'purchase'
      get 'receipt'
      get 'privates/:id', to: redirect('/privates/%{id}')
    end

    scope module: 'event' do
      resources :photos, only: [:index]
      resources :ledger, only: [:index]
      resources :members, only: [:index]
    end
  end

  resources :privates, only: [:show]

  resources :photos, only: [:create, :destroy]
  resources :attendees, only: [:update]

  get '/workshops', to: redirect('/events')
  get '/milongas', to: redirect('/events')
  resources :locations, only: [:show]

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end

  match '/404', via: :all, to: 'application#not_found'
  match '/500', via: :all, to: 'application#internal_server_error'
  match '*any', via: :all, to: 'application#not_found'
end
