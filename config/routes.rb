Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'login_guest', to: 'sessions#create_guest'
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
    end
  end
  
  resources :favorites, only: [:create, :destroy]
  
end