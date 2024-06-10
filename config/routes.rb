Rails.application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root 'pages#index'
  get 'pages/index'
  resources :books
  resources :carts, only: [:show]
  resources :cart_items, only: [:create, :edit, :update, :destroy]
  get 'checkout', to: 'carts#checkout', as: 'checkout'
  post 'complete_order', to: 'carts#complete_order', as: 'complete_order'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
