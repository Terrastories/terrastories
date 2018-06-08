Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get  'point' => 'home#show'
  post 'point' => 'home#create'
  resources :points
end
