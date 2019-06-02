#!/bin/sh

if [ -L node_modules -a ! -w node_modules/. ]; then
  echo "Cleaning old node_modules link"
  rm node_modules
fi

echo "Removing artifacts from previous run"
rm -rf /app/log/*
# rm -rf /app/tmp/pids/*
# touch /app/log/.keep
# touch /app/tmp/.keep

echo "Installing bundled gems"
bundle install

echo "Installing yarn"
yarn install

if echo "ActiveRecord::Base.logger = nil; ActiveRecord::Base.connection.tables" | bundle exec rails console | grep schema_migrations 2>&1 > /dev/null \
; then
  echo "Running pending migrations"
  bundle exec rails db:migrate

else
  echo "Performing first-time setup"
  bundle exec rails db:setup
fi

echo "Running gem updates tasks"
bundle exec rails acts_as_taggable_on_engine:install:migrations
bundle exec rails webpacker:compile

echo "Starting server"
exec bundle exec rails server -p 3000 -b '0.0.0.0'
