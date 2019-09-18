source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.6.4'

# Load .env* before everything
# See https://github.com/bkeepers/dotenv#note-on-load-order
gem 'dotenv-rails', require: 'dotenv/rails-now', group: %i[development test]

gem 'rails', '~> 5.2.0'

# Core
gem 'puma', '~> 3.11'
gem 'sqlite3'
gem 'pg', '>= 0.18', '< 2.0', group: "postgres"

# Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'font-awesome-rails', '~> 4.7'
gem 'webpacker', '~> 3.5'
gem 'plyr-rails'
gem 'react-rails'

# Views
gem 'jbuilder', '~> 2.5'
gem 'i18n-js'

# Extensions
gem 'foreman'
gem 'devise'
gem 'pundit'
gem 'administrate'
gem 'administrate-field-active_storage'
gem 'acts-as-taggable-on', '~> 5.0'
gem 'mapbox-gl-rails'
gem 'rgeo-geojson'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby


# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'guard-rspec'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

