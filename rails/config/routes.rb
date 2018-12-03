Rails.application.routes.draw do
  namespace :admin do
    resources :demographics
    resources :users
    resources :points
    resources :speakers
    resources :stories
    resources :places

    root to: "users#index"
  end

  scope "(:locale)", locale: /en|mat/ do
    resources :places do
      collection do
        post :import_csv
      end
    end
    resources :stories do
      collection do
        post :import_csv
      end
    end
    devise_for :users, :controllers => { registrations: 'registrations' }
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root to: 'welcome#index'
    get 'home', to: 'home#index', as: "home_map"
    resources :points
    resources :speakers do
      collection do
        post :import_csv
      end
    end
  end
end
