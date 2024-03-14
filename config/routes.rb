Rails.application.routes.draw do
  get 'chats/index'
  devise_for :users

  resources :restaurants, only: [:index, :show] do
    resources :favorites, only: :create
  end
  resources :favorites, except: :create

  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'chats/index'
  get '/api', to: 'api#index'
  # Defines the root path route ("/")
  # root "posts#index"
  get '/filter', to: 'restaurants#filter'
  get '/places/:id', to: 'places#show'
  get '/places', to: 'places#index'
  
  get '/show', to: 'pages#show'
  
  get '/profile', to: 'profiles#show'
  get '/page_three', to: 'pages#page_three'

  get 'chats', to: 'chats#index', as: :chat
  get 'custom_restaurants', to: 'chats#custom_restaurants'


end
