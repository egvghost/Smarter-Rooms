Rails.application.routes.draw do
  resources :reservations, only: [:index, :show, :new, :create, :destroy]
  resources :accessories
  resources :rooms
  resources :buildings
  resources :users
  get '/occupancy', to: 'rooms#occupancy'
  get '/statistics', to: 'reservations#statistics'
  get '/all_reservations', to: 'reservations#all'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new' 
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create' 
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
