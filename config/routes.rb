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
  namespace :users do
    get 'video_common_like/:video_unique_id',  to: 'video_common_like#index', as: 'video_common_like'
  end
  resources :qiitas
  namespace :youtube do
    resources :videos_search
    # resources :myvideos
    get '/myvideos/:q', to: 'myvideos#index', as: 'myvideos'
    namespace :myvideos do
      resources :favorites, only: [:create, :update]
      namespace :status do
        resources :like, only: [:index, :destroy]
        namespace :like do
          resources :share, only: [:new, :create]
        end
        get 'like/:keyword', to: 'like#index'
        resources :dislike
      end
    end
  end
end
