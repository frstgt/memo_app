Rails.application.routes.draw do

  get 'pen_names/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  get  '/signup',  to: 'users#new'
  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :pen_names

  resources :groups
  resources :groups do
    get :members, on: :member
  end

  resources :notes
  resources :notes do
    resources :memos,      only: [:new, :create, :edit, :update, :destroy]
  end

end
