# frozen_string_literal: true

Rails.application.routes.draw do
  root :to => redirect('users')
  devise_for :users
  resources :users, only: [:index, :show]
  resources :food, only: [:index, :show, :new, :create, :destroy]
end
