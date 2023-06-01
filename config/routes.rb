# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root :to => redirect('foods')
  resources :users, only: [:index, :show]
  resources :foods, only: [:index, :show, :new, :create, :destroy]
  resources :recipes do
    member do
      get 'details'
    end
  end
  
  get '/public_recipes', to: "recipe_foods#index"
  #delete '/recipes/destroy/:id', to: "recipes#destroy_food"
end
