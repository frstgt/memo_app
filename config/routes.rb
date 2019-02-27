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

  resources :pen_names, only: [:new, :create, :edit, :update, :destroy]

  resources :user_notes, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :user_notes, as: 'unotes' do
    resources :user_memos, as: 'umemos', only: [:new, :create, :edit, :update, :destroy]

    get :to_book, on: :member
  end

  resources :groups
  resources :groups do

    resources :group_notes, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :group_notes, as: 'gnotes' do
      resources :group_memos, as: 'gmemos',  only: [:new, :create, :edit, :update, :destroy]

      get :to_book, on: :member
    end

    get :members, on: :member

  end

  resources :books, only: [:new, :create]
  resources :books do
    resources :pages, only: [:new, :create]
    get :inside, on: :collection # site
    get :outside, on: :collection # public
  end

end
