Rails.application.routes.draw do
  # Devise のルーティング
  devise_for :users

  # ユーザー関連のルーティング
  resources :users, only: [:show, :edit, :update]

  # 施設 (Room) 関連のルーティング
  resources :rooms, only: [:index, :show, :new, :create] do
    # 施設に紐づく予約 (Reservation) のルーティング
    resources :reservations, only: [:new, :create]
  end

  # 予約 (Reservation) 一覧・詳細のルーティング
  resources :reservations, only: [:index, :show]

  # トップページを rooms#index に設定
  root "rooms#index"
end