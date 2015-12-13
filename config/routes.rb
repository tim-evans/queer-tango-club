Rails.application.routes.draw do
  resources :packages
  resources :events
  resources :members

  namespace :webhooks do
    post 'square', to: 'square#receive'
  end
end
