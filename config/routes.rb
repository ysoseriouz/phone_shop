Rails.application.routes.draw do
  root 'inventories#index'
  resources :inventories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
