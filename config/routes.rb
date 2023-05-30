# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root :to => redirect('foods')
  resources :users, only: [:index, :show]
  resources :foods, only: [:index, :show, :new, :create, :destroy]

  get '/public_recipes', to: "recipe_foods#index"
end
