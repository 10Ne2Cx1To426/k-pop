Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'

  resources :events do
    resources :joins, only: [:index, :create, :destroy]
  end

  resources :groups, only: [:index, :new, :create] do
    resources :messages, only: [:index, :create]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index, :edit, :update, :show] do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end

  resources :dms, only: [:create]

  resources :rooms, only: [:create, :show, :index]
end
