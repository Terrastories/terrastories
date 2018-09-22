echo "Removing existing yarn modules from host"
rm -rf /app/node_modules /app/yarn.lock
echo "Copying container yarn modules"
mv /node_modules /app/node_modules
echo "Removing artifacts from previous run"
mv /yarn.lock /app/yarn.lock
rm -f /app/tmp/pids/server.pid

if echo "ActiveRecord::Base.logger = nil; ActiveRecord::Base.connection.tables" | bundle exec rails console | grep schema_migrations 2>&1 > /dev/null \
; then
  echo "Running pending migrations"
  bundle exec rails db:migrate
else
  echo "Performing first-time setup"
  bundle exec rails db:setup
fi

echo "Starting server"
bundle exec rails server -p 3000 -b '0.0.0.0'
