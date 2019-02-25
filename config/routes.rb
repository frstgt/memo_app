Rails.application.routes.draw do

  get 'pen_names/new'

  root 'static_pages#home' # public and site
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  get  '/signup',  to: 'users#new'
  resources :users
  resources :users do
    get :books, on: :member # private
  end
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :pen_names,    only: [:show, :new, :create, :edit, :update, :destroy]

  resources :groups
  resources :groups do
    get :members, on: :member
    get :books, on: :member # group
  end

  resources :notes,        only: [:new, :create, :edit, :update, :destroy]
  resources :notes do
    resources :memos,      only: [:new, :create, :edit, :update, :destroy]
  end

  resources :books,        only: [:new, :create]
  resources :books do
    resources :pages,      only: [:new, :create]
    get :public, on: :collection # public
    get :site,   on: :collection # site
  end

  # gnotes, gmemos

  # gbooks, gpages

end
