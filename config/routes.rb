Rails.application.routes.draw do
  root to: 'home#index' 

  devise_for :users, controllers: { registrations: "registrations" }

  resources :categories
  resources :products 
  resources :brands
  resources :charges

  get "/cart", to: "order_items#index"
  resources :order_items, path: "/cart/items"

  get "/cart/checkout", to: "orders#new", as: :checkout
  patch "/cart/checkout", to: "orders#create", as: :confirm_order
  get "/orders/:id", to: "orders#show", as: :order

  get "/room/:id", to: "room#show", as: :room
  get "/rooms", to: "room#index", as: :rooms

  resources :messages, only: [:create]

  patch "/orders/complete_order/:id", to: "orders#complete_order", as: :complete_order

  post 'sms/create', to: "sms#create"
  get 'sms/new'

  mount ActionCable.server => "/cable"

end
