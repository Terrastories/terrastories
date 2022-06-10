require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Setup i18n Module
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.{rb,yml}').to_s]
    config.i18n.available_locales = Dir[Rails.root.join('config','locales', '*')].map {|f| File.basename(f).to_sym }
    config.i18n.default_locale = :en

    # Don't replace existing images on upload for has_many_attached
    config.active_storage.replace_on_assign_to_many = false
  end
end
