# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    constraints subdomain: 'member' do
      scope module: 'dashboard' do
        root to: 'stories#index', as: 'member_root'

        resources :users
        resources :speakers
        resources :places
        resources :stories
        resource :theme, only: [:update, :edit] do
          delete '/sponsor_logo/:id/delete', action: :delete_sponsor_logo, as: :delete_sponsor_logo
        end
      end
    end

    devise_for :users, :controllers => { registrations: 'registrations' }
    root to: 'welcome#index'
    get 'home', to: 'home#index', as: "home_map"
    get "search", to: "home#community_search_index", as: "community_search"
  end

  namespace :admin do
    resources :communities
    resources :users
    resources :curriculums
    resources :speakers do
      collection do
        post :import_csv
        get  :import_page
        get  :export_sample_csv
      end
    end
    resources :stories do
      collection do
        post :import_csv
        get  :export_sample_csv
        get  :import_page
      end
    end
    resources :places do
      collection do
        post :import_csv
        get  :import_page
        get  :export_sample_csv
      end
    end
    delete :places_destroy_name_audio, to: 'places#destroy_name_audio'

    resources :curriculum_stories
    resources :themes
    # resources :media_links

    root to: "communities#show"
  end

    delete '/admin/places' => 'places#delete'
    delete '/admin/stories' => 'admin/stories#delete'
    delete '/admin/themes' => 'admin/themes#delete'
    delete '/admin/speakers' => 'admin/speakers#delete'
end
