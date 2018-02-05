Rails.application.routes.draw do
  resources :product

  root 'product#index' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
