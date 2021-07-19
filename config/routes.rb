# frozen_string_literal: true

Rails.application.routes.draw do
  root 'inventories#index'
  devise_for :accounts
  resources :inventories
  resources :brands, only: %i[index destroy]
  resources :models, only: [:destroy]
  post 'brands/create'
  patch 'brands/update'
  post 'models/create'
  patch 'models/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
