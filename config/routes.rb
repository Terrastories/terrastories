Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :speakers
    resources :stories
    resources :places
    resources :curriculums

    root to: "users#index"
  end

    delete '/admin/places' => 'places#delete'
    delete '/admin/stories' => 'stories#delete'

  scope "(:locale)", locale: Regexp.union(I18n.available_locales.map(&:to_s)) do
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
    resources :speakers do
      collection do
        post :import_csv
      end
    end
  end
end
