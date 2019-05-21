Myflix::Application.routes.draw do
  root to: 'pages#index'
  get 'index', controller: 'pages', action: 'index'

  get 'ui(/:action)', controller: 'ui'
 
  get 'register', controller: 'users', action: 'new'
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  post 'register', controller: 'users', action: 'create', as: 'users'

  get 'login', controller: 'sessions', action: 'new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  post 'update_queue', to: "queue_items#update_queue"
  get 'my_queue', to: 'queue_items#index'

  get 'people', to: 'relationships#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'pages#expired_token'


  resources :videos, only:[:show, :index] do 
    resources :reviews, only: [:create]
    collection do 
  		get '/search', to: 'videos#display'
  	end 
  end

  resources :users, only: [:show]
  resources :categories, only:[:show]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy, :create]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :invitations, only: [:new, :create]
end
