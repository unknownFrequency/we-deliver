Rails.application.routes.draw do
  get 'categories/index'

  get 'categories/create'

  get 'categories/edit'

  get 'categories/update'

  get 'categories/show'

  get 'index/create'

  get 'index/edit'

  get 'index/update'

  get 'index/show'

  devise_for :users

  resources :categories
  resources :products do
    resources :categories
    resources :brands
  end

  root to: 'products#index' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
