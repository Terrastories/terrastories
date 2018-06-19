Rails.application.routes.draw do
  resources :stories
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  get 'home', to: 'home#index', as: "home_map"
  resources :points
  resources :speakers
end
