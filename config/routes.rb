Rails.application.routes.draw do
  root to: 'products#index' 

  devise_for :users

  resources :products do
    resources :categories
    resources :brands
  end

  get "/cart", to: "order_items#index"
  resources :order_items, path: "/cart/items"

  get "/cart/checkout", to: "orders#new", as: :checkout
  patch "/cart/checkout", to: "orders#create"
  # resources :orders

end
