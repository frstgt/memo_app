Rails.application.routes.draw do

  mathjax 'mathjax'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  resources :users
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :pen_names, only: [:show, :new, :create, :edit, :update, :destroy]

  resources :notes do
    resources :memos,    only: [:new, :create, :edit, :update, :destroy]
    resources :pictures, only: [:new, :create, :edit, :update, :destroy]

    get :set_point, on: :member
  end
  resources :notes, only: [:index]
  resources :rooms do
    resources :messages,    only: [:create]
  end

  resources :user_notes, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :user_rooms, only: [:show, :new, :create, :edit, :update, :destroy]

  resources :groups do
    resources :group_notes, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :group_rooms, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :members, only: [:index]

    get :join, on: :member
    get :unjoin, on: :member
    get :change_leader, on: :member
    get :position, on: :member
  end
  resources :groups, only: [:show, :new, :create, :edit, :update, :destroy]

  resources :tags, only: [:show]

end
