Rails.application.routes.draw do
  devise_for :users
  resources :products do
    resources :categories
    resources :brands
  end

  root to: 'products#index' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
