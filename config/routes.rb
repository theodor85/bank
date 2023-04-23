# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts do
    resources :cards, except: %i[index show update]
    resources :transfers
  end

  get 'home/index'
  devise_for :users
  root to: 'home#index'
end
