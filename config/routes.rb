Rails.application.routes.draw do
  devise_for :users,
    controllers: { 
      registrations: 'registrations',
      sessions: :sessions
    }
  
  root 'top#index'
  resources :users, only: [:show, :index]
  resources :reactions, only: [:create]
  resources :matching, only: [:index]
  resources :chat_rooms, only: [:create, :show]
  resources :qiitas
  namespace :youtube do
    resources :videos, only: [:index]
    namespace :videos do
      resources :like, only: [:show, :index]
      resources :dislike, only: [:show, :index]
    end
  end
end
