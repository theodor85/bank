# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, except: %i[destroy] do
    resources :cards, except: %i[index show update]
    resources :transfers, except: %i[update destroy]
  end

  resources :profiles, only: %i[show edit update]

  get 'home/index'
  devise_for :users
  root to: 'home#index'
end
