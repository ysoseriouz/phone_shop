Rails.application.routes.draw do
  root 'inventories#index'
  resources :inventories
  resources :brands, only: [:index, :destroy]
  resources :models, only: [:destroy]
  post 'brands/create'
  post 'brands/update'
  post 'models/create'
  post 'models/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
