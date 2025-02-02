Rails.application.routes.draw do
  # Devise のルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # ユーザー関連のルーティング
  resources :users, only: [] do
    member do
      get :edit, to: 'users#edit' # /users/:id/edit
      get :edit_profile, to: 'users#edit_profile' # プロフィール編集フォーム
      patch :update_profile, to: 'users#update_profile' # プロフィール更新
    end
  end

  resources :users, only: [:edit, :update]

  # ルームと予約のルート
  resources :rooms, only: [:index, :show, :new, :create] do
    resources :reservations, only: [:new, :create] do
      post :confirm, on: :collection
    end
  end

  # 施設関連のルート
  resources :facilities, except: [:show] do
    get :registered, on: :collection
  end

  # 予約関連のルート（showを追加）
  resources :reservations, only: [:index, :show, :destroy, :create, :update] do
    member do
      get :confirm # 確認ページ
    end
  end
  
  # 予約一覧用のルーティングを追加
  resources :reservations, only: [:index, :show, :destroy]


  # Booking のルートを追加
  resources :bookings, only: [:new, :create, :index]

  # Devise のサインアウトルート
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # ルートページ
  root "rooms#index"
end