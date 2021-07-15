Rails.application.routes.draw do
  devise_for :accounts
  root 'inventories#index'
  resources :inventories
  get 'brand_models/index'
  post 'brand_models/create_model'
  post 'brand_models/create_brand'
  post 'brand_models/update_model'
  post 'brand_models/update_brand'
  delete 'brand_models/destroy_brand/:id', to: 'brand_models#destroy_brand'
  delete 'brand_models/destroy_model/:id', to: 'brand_models#destroy_model'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
