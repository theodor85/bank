# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts
  get 'home/index'
  devise_for :users
  root to: 'home#index'
end
