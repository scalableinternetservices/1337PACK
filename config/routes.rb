Rails.application.routes.draw do
  get 'users/index'
  get 'users/show/:id', to: 'users#show'
  put 'users/:id', to: 'users#update'
  delete 'users/:id', to: 'users#destroy'
  get 'events/index'
  get 'events/show/:id', to: 'events#show'
  put 'events/:id', to: 'events#update'
  get 'comments/index'
  get 'invites/index'
  get 'rsvps/index'
  post 'auth/login', to: 'authentication#login'
  root 'home#index'
  # get '/*path' => 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :events
  resources :rsvps
  resources :invites
  resources :comments
  resources :users
end
