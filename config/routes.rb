Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :followings
      get :followers
      get :edit_account
      get :edit_profile
      get :posts
      get :search#できればusers/:id/posts/searchというurlにしたいが..
      post :create
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
      # post :search#多分いらん
    end
  end
  #get 'search', to: 'topics#search'
  
  resources :favorites, only: [:create, :destroy]
  
  post 'guest_login', to: 'guest_sessions#create'
end