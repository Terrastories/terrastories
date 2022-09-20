# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    scope '/member' do
      scope module: 'dashboard' do
        get '/', to: 'communities#index', as: :super_admin_root, constraints: RoleRoutingConstraint.new { |user| user.super_admin }
        get '/', to: 'stories#index', as: :member_root, constraints: RoleRoutingConstraint.new { |user| !user.super_admin }

        get :search, to: "search#index"

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
        resources :communities
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
