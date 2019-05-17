Myflix::Application.routes.draw do
  root to: 'pages#index'
  get 'index', controller: 'pages', action: 'index'

  get 'ui(/:action)', controller: 'ui'
 
  get 'register', controller: 'users', action: 'new'
  post 'register', controller: 'users', action: 'create', as: 'users'

  get 'login', controller: 'sessions', action: 'new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  post 'update_queue', to: "queue_items#update_queue"
  get 'my_queue', to: 'queue_items#index'

  get 'people', to: 'relationships#index'


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
end
