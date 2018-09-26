Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :points
      resources :speakers
      resources :stories

      root to: "users#index"
    end
  resources :stories
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  get 'home', to: 'home#index', as: "home_map"
  resources :points
  resources :speakers
end
