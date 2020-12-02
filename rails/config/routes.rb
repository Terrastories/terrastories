Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :curriculums
    resources :speakers do
      collection do
        post :import_csv
      end
    end
    resources :stories do
      collection do
        post :import_csv
        get  :export_sample_csv
      end
    end
    resources :places do
      collection do
        post :import_csv
      end
    end
    resources :curriculum_stories
    resources :themes
    # resources :media_links

    root to: "users#index"
  end

    delete '/admin/places' => 'places#delete'
    delete '/admin/stories' => 'stories#delete'
    delete '/admin/themes' => 'admin/themes#delete'

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
    get "search", to: "home#community_search_index", as: "community_search"
    resources :speakers do
      collection do
        post :import_csv
      end
    end
  end
end
