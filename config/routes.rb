Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  
  get 'signup', to: 'users#new'
  # get 'edit_profile', to: 'users#edit_profile'
  # get 'edit_account', to: 'users#edit_account'
  resources :users, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :followings
      get :followers
      get :edit_account
      get :edit_profile
      get :posts
    end
    
  end
  
  resources :relationships, only: [:create, :destroy]
  
  resources :microposts, only: [:show, :create, :destroy]do
    member do
      get :search
    end
  end
  
  resources :topics, only: [:index, :create, :destroy]do
    collection do
      get :search
      post :search
    end
  end
  #get 'search', to: 'topics#search'
  
  resources :favorites, only: [:create, :destroy]
  
end