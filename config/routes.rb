Rails.application.routes.draw do
  root to: 'home#index'

  jsonapi_resources :attendees
  jsonapi_resources :discounts
  jsonapi_resources :events
  jsonapi_resources :expenses
  jsonapi_resources :groups
  jsonapi_resources :guests
  jsonapi_resources :locations
  jsonapi_resources :members
  jsonapi_resources :photos
  jsonapi_resources :privates
  jsonapi_resources :sessions
  jsonapi_resources :teachers
  jsonapi_resources :transactions
  jsonapi_resources :users

  resources :purchases, only: [:create]
  resources :user_sessions, except: [:show, :update]
  get 's3-direct', to: 's3_direct#get'

  match '/404', via: :all, to: 'application#not_found'
  match '/500', via: :all, to: 'application#internal_server_error'
  match '*any', via: :all, to: 'application#not_found'
end
