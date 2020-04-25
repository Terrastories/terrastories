source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem "dotenv-rails", require: "dotenv/rails-now", group: %i[development test]

gem 'rails', '~> 5.2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Already has rgeo
gem 'rgeo-geojson'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby
gem 'acts-as-taggable-on', '~> 5.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'rails-i18n'
gem 'devise'
gem 'devise-i18n'
gem 'pundit'
gem 'administrate'
gem 'administrate-field-active_storage'
gem "administrate-field-nested_has_many"

# Enable Webpack for javascript application code
gem 'webpacker', '~> 3.5'
gem 'react-rails'

gem 'font-awesome-rails', '~> 4.7'

# plyr-rails gem is the integration of plyr.io javascript library for your Rails 4 and Rails 5 application.
gem 'plyr-rails'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Internationalization in JS
gem 'i18n-js'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
  gem 'bundler-audit'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Add better error handling to make debugging simpler
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  # Factories for creating database entities for testing
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  # Gem with utilities to test controllers
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mapbox-gl-rails'
