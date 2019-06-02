#!/bin/sh

echo "Removing artifacts from previous run"
rm -rf /app/log/*
# leaving /app/tmp to preserve cache for faster restart in prod
# rm -rf /app/tmp/*

if echo "ActiveRecord::Base.logger = nil; ActiveRecord::Base.connection.tables" | bundle exec rails console | grep schema_migrations 2>&1 > /dev/null \
; then
  echo "Running pending migrations"
  bundle exec rails db:migrate

else
  echo "Performing first-time setup"
  bundle exec rails db:setup
fi

#echo "Running gem updates tasks"
# Run these as part of prod Dockerfile to reduce startup time
#bundle exec rails acts_as_taggable_on_engine:install:migrations
#bundle exec rails webpacker:compile

echo "Starting server"
exec bundle exec rails server -p 3000 -b '0.0.0.0'
