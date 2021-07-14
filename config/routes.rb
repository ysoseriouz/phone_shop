Rails.application.routes.draw do
  root 'inventories#index'
  resources :inventories
  get 'brand_models/index'
  post 'brand_models/create_model'
  post 'brand_models/create_brand'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
