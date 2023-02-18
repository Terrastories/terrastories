require "active_support/core_ext/integer/time"

# Offline Environment
#
# This environment should only be used for deployed offline environments.
# If you are developing features for offline environments, please continue
# to use the development environment.

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Print deprecation notices to the Rails logger.
  # :notify in production; offline we want to log locally.
  config.active_support.deprecation = :log

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use default logging formatter so that PID and timestamp are not suppressed
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true

  # Serve static assets from /public folder
  config.public_file_server.enabled = true

  # Compress JS using a preproccessor
  config.assets.js_compressor = :terser

  # Compress CSS using a preproccessor
  config.assets.css_compressor = :sass

  # Fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.hosts << "terrastories.local"
  config.hosts << /[a-zA-Z0-9-]*\.terrastories\.local/
  config.hosts << ENV["HOST_HOSTNAME"] if ENV["HOST_HOSTNAME"].present?
end
