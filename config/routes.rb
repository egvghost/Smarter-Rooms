Rails.application.routes.draw do
  resources :reservations#, only: [:index, :show, :new, :create, :destroy]
  resources :accessories
  resources :rooms
  resources :buildings
  resources :users
  get '/occupancy', to: 'rooms#occupancy'
  get '/charts', to: 'reservations#charts'
  get '/all_reservations', to: 'reservations#all'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new' 
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create' 
  delete '/logout', to: 'sessions#destroy'
  post '/schedule', to: 'reservations#schedule' 
  post '/reserve', to: 'reservations#reserve' 
  post '/switch_role', to: 'users#switch_role' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
