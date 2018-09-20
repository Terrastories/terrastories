printf "\nRemoving existing yarn modules from host ..."
rm -rf /app/node_modules /app/yarn.lock
printf "done\n"
printf "Copying container yarn modules ..."
mv /node_modules /app/node_modules
mv /yarn.lock /app/yarn.lock
printf "done\n"
rm -f /app/tmp/pids/server.pid

if echo "ActiveRecord::Base.logger = nil; ActiveRecord::Base.connection.tables" | bundle exec rails console | grep schema_migrations 2>&1 > /dev/null \
; then
  printf "Running pending migrations\n"
  bundle exec rails db:migrate
else
  printf "Performing first-time setup\n"
  bundle exec rails db:setup
fi

printf "Starting server\n"
bundle exec rails server -p 3000 -b '0.0.0.0'
