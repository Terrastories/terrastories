#!/bin/sh

# echo "Removing existing yarn modules from host"
# rm -rf /app/node_modules /app/yarn.lock
# cp -rf /node_modules /app/node_modules

echo "Copying container yarn lock"
cp -rf /yarn.lock /app/yarn.lock

echo "Removing artifacts from previous run"
rm -rf /app/log/*
rm -rf /app/tmp/*
touch /app/log/.keep
touch /app/tmp/.keep

echo "Installing bundled gems"
bundle install

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
