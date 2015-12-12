Rails.application.routes.draw do
  resources :packages
  resources :events
  resources :members
end
