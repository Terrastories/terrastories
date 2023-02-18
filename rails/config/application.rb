require_relative "boot"

require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
# require "action_mailer/railtie"
# require "active_job/railtie"
# require "action_cable/engine"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "rails/test_unit/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Setup i18n Module
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*', '*.{rb,yml}').to_s]
    config.i18n.available_locales = Dir[Rails.root.join('config','locales', '*')].map {|f| File.basename(f).to_sym }
    config.i18n.default_locale = :en
    # Set default locale fallback to :en
    config.i18n.fallbacks.defaults = [:en]
    # and configure language-specific fallbacks when needed
    config.i18n.fallbacks.map = {mat: [:nl, :en]}

    # Don't replace existing images on upload for has_many_attached
    config.active_storage.replace_on_assign_to_many = false
  end
end
