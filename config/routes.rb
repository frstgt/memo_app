Rails.application.routes.draw do

  get 'pen_names/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  resources :users
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :pen_names do
    
    get :to_open, on: :member
    get :to_close, on: :member

    get :books, on: :member
  end
  resources :pen_names

  resources :user_notes, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :user_notes do
    resources :user_memos, only: [:new, :create, :edit, :update, :destroy]

    get :to_book, on: :member
  end

  resources :groups do

    resources :group_notes, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :group_notes do
      resources :group_memos,  only: [:new, :create, :edit, :update, :destroy]

      get :to_open, on: :member
      get :to_close, on: :member
      get :to_book, on: :member
    end

    get :to_open, on: :member
    get :to_close, on: :member

    get :books, on: :member

    get :members, on: :member
    get :join, on: :member
    get :unjoin, on: :member
    get :change_leader, on: :member
    get :position, on: :member
  end
  resources :groups

  resources :books, only: [:new, :create]
  resources :books do
    resources :pages, only: [:new, :create]

    get :evaluate, on: :member
  end

end
