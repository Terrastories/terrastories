# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    scope '/member', module: 'dashboard', constraints: RoleRoutingConstraint.new { |user| !user.super_admin } do
      root to: "stories#index", as: :member_root

      get :search, to: "search#index"
      get :profile, to: "users#profile", as: :user_profile

      resource :community, only: [:show, :update], as: :community_settings
      resources :users do
        delete :photo, action: :delete_photo
      end
      resources :speakers do
        delete :photo, action: :delete_photo
      end
      resources :places do
        delete :photo, action: :delete_photo
        delete :name_audio, action: :delete_name_audio
      end
      resources :stories do
        delete '/media/:id/delete', action: :delete_media, as: :delete_media
      end
      resource :theme, only: [:update, :edit, :show] do
        delete :background_img, action: :delete_background_img
        delete '/sponsor_logo/:id/delete', action: :delete_sponsor_logo, as: :delete_sponsor_logo
      end
      resource :import, only: [:show, :create] do
        post :preview
      end
    end

    # super admin resource routes
    scope '/admin', module: 'super_admin', constraints: RoleRoutingConstraint.new { |user| user.super_admin } do
      root to: "metrics#show", as: :super_admin_root

      resource :metrics, only: :show
      resources :communities
      resources :features do
        post :enable
        post :disable
      end
    end

    devise_for :users, :controllers => { registrations: 'registrations' }
    root to: 'welcome#index'
    get 'home', to: 'home#index', as: "home_map"
    get "search", to: "home#community_search_index", as: "community_search"

    get :onboard, to: "onboard#start", as: :start_onboarding
    namespace :onboard do
      resource :community, controller: :community, only: [:show, :create], as: :community
      resource :account, controller: :account, only: [:show, :create], as: :admin_account
    end
  end
end
