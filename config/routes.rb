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

  # その他のルートはそのまま
  resources :rooms, only: [:index, :show, :new, :create] do
    resources :reservations, only: [:new, :create] do
      post :confirm, on: :collection
    end
  end

  resources :facilities, only: [:new, :create, :index, :destroy]
  get 'registered_facilities', to: 'facilities#index', as: 'registered_facilities'
  resources :reservations, only: [:index, :destroy]

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  root "rooms#index"
end