# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, except: %i[destroy] do
    resources :cards, only: %i[new create]
    resources :transfers, only: %i[new create]
  end

  resources :profiles, only: %i[show edit update]

  get 'home/index'
  devise_for :users
  root to: 'home#index'
end
