# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root :to => redirect('foods')
  resources :users, only: [:index, :show]
  resources :foods, only: [:index, :show, :new, :create, :destroy]
  resources :recipes do
    member do
      get 'details'
      delete 'destroy/:id', to: 'recipes#destroy_food'
      get 'new_ingredient', to:'recipes#new_ingredient'
      post 'add_ingredient', to:'recipes#add_ingredient'
    end
  end
  
  get '/public_recipes', to: "recipe_foods#index"
  #delete '/recipes/destroy/:id', to: "recipes#destroy_food"
end
