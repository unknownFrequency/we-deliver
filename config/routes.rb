Rails.application.routes.draw do
  get 'messages/xreate'

  root to: 'products#index' 

  devise_for :users

  resources :products do
    resources :categories
    resources :brands
  end

  get "/cart", to: "order_items#index"
  resources :order_items, path: "/cart/items"

  get "/cart/checkout", to: "orders#new", as: :checkout
  patch "/cart/checkout", to: "orders#create", as: :confirm_order
  get "/orders/:id", to: "orders#show", as: :order

  get "/room/:id", to: "room#show", as: :room
  get "/rooms", to: "room#index", as: :rooms

  resources :messages, only: [:create]

  # post "/notifications/:id", to: "room#notifications"


  mount ActionCable.server => "/cable"

end
