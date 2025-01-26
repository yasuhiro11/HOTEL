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
  resources :facilities, only: [:new, :create, :index, :destroy]
  get 'registered_facilities', to: 'facilities#index', as: 'registered_facilities'

  # 予約関連のルート
  resources :reservations, only: [:index, :destroy]

  # Booking のルートを追加
  resources :bookings, only: [:new, :create]

  # Devise のサインアウトルート
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # ルートページ
  root "rooms#index"
end