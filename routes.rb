Rails.application.routes.draw do
  devise_for :users,
    controllers: { 
      registrations: 'registrations',
      sessions: :sessions,
      passwords: 'passwords'
    }
    
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  root 'top#index'
  resources :users, only: [
    :show,  # ユーザー詳細画面
    :index  # ユーザータイプ画面
  ], param: :user_id
  resources :users do
    resources :video_share, only: [
      :new, # 他のユーザーへの動画共有画面
      # :create # 非画面表示
    ], controller: 'users/video_share'
    resource :status do
      resources :like, only: [
        :index # 自分がタイプしたユーザー一覧画面
      ], controller: 'users/status/like'
    end
  end
  namespace :admin do
    root 'top#index' # 管理者画面トップページ（ログインページ）
    resources :dashboard, only: [
      :index # 管理者画面ダッシュボード
    ]
    resource :dashboard do
      resources :users, controller: 'dashboard/users' # Userモデルレコード操作ページ(一覧・詳細・編集)
      resources :youtube_videos, controller: 'dashboard/youtube_videos' # YoutubeVideoモデルレコード操作ページ(一覧・詳細・編集)
      resources :chat_rooms, controller: 'dashboard/chat_rooms' # ChatRoomモデルレコード操作ページ(一覧・詳細・編集)
      resources :chat_room_users, controller: 'dashboard/chat_room_users' # ChatRoomUserモデルレコード操作ページ(一覧・詳細・編集)
      resources :chat_messages, controller: 'dashboard/chat_messages' # ChatRoomUserモデルレコード操作ページ(一覧・詳細・編集)
      resources :reactions, controller: 'dashboard/reactions' # Reactionモデルレコード操作ページ(一覧・詳細・編集)
      resources :favorites, controller: 'dashboard/favorites' # Favoriteモデルレコード操作ページ(一覧・詳細・編集)
      resources :share_videos, controller: 'dashboard/share_videos' # ShareVideoモデルレコード操作ページ(一覧・詳細・編集)
    end
  end
  namespace :demo_admin do
    root 'top#index' # デモ管理者画面トップ（ログイン）画面
    resources :dashboard, only: [
      :index # デモ管理者画面ダッシュボードトップ
    ]
    resource :dashboard do
      resources :users, controller: 'dashboard/users' # デモUserモデル操作画面（一覧・詳細・編集）
      resources :youtube_videos, controller: 'dashboard/youtube_videos' # デモYoutubeVideoモデル操作画面（一覧・詳細・編集）
      resources :chat_rooms, controller: 'dashboard/chat_rooms' # デモChatRoomモデル操作画面（一覧・詳細・編集）
      resources :chat_room_users, controller: 'dashboard/chat_room_users' # デモChatRoomUserモデル操作画面（一覧・詳細・編集）
      resources :chat_messages, controller: 'dashboard/chat_messages' # デモChatMessageモデル操作画面（一覧・詳細・編集）
      resources :reactions, controller: 'dashboard/reactions' # デモReactionモデル操作画面（一覧・詳細・編集）
      resources :favorites, controller: 'dashboard/favorites' # デモFavoriteモデル操作画面（一覧・詳細・編集）
      resources :share_videos, controller: 'dashboard/share_videos' # デモShareVideoモデル操作画面（一覧・詳細・編集）
    end
  end

  resources :reactions, only: [
    # :create # ユーザーへのタイプリアクション(非画面表示)
  ]
  resources :matching, only: [
    :index # マッチングしているユーザー一覧（チャットルーム作成画面）
  ]
  resources :chat_rooms, only: [
    # :create, # チャットルーム作成アクション（非画面表示）
    :show # チャットルーム画面
  ]
  namespace :users do
    get 'video_common_like/:video_unique_id', # 共通の動画をLikeしているユーザーの一覧画面
    to: 'video_common_like#index', 
    as: 'video_common_like'
  end
  namespace :youtube do
    resources :videos_search
      get '/myvideos/:q', # YouTubeAPI検索結果表示ページ
      to: 'myvideos#index',
      as: 'myvideos'
    namespace :myvideos do
      resources :favorites, only: [
        # :create, # 動画お気に入り機能（非画面表示） 
        # :update # 動画お気に入りステータスの更新（非画面表示）
      ]
      namespace :status   do
        resources :like, only: [
          :index, # 自分がLikeした動画の一覧表示画面(検索ワードなし)
          # :destroy # 自分がLikeした動画の削除機能
        ]
        namespace :like do
          resources :share, only: [
            :new, # 動画共有ユーザー選択画面
            # :create # 動画共有アクション（非画面表示）
          ]
          resources :shared_and_sharing_history,
          only: [
            :show # 動画共有履歴表示ページ
          ], 
          param: :user_id
          resources :sharing_videos, only: [
            # :index # 不要 (後述↓の resouces: shared_and_sharing_videosで代替)
          ]
          resources :sharing_videos, 
          param: :video_unique_id, only: [
            # :show # 不要(後述↓の resouces: shared_and_sharing_videosで代替)
          ]
          resources :shared_and_sharing_videos, only: [
            :show # チャットルーム相手と共有されている・共有している動画一覧
          ]
        end
        get 'like/:keyword', # 自分がLikeした動画の一覧表示画面(検索ワードあり)
        to: 'like#index'
        resources :dislike, only: [
          :index, # 自分がDislikeした動画の一覧画面
          # :destroy # 自分がDislikeした動画の削除（非画面表示）
        ]
      end
    end
  end
end
