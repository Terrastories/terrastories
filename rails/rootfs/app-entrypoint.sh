#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page
check_for_updates &

INIT_SEM=/tmp/initialized.sem

if [ -z "$DATABASE_URL" ]; then
  log "Error: DATABASE_URL not defined in the environment"
  exit 1
fi

DATABASE_ADAPTER=$(sed -e "s/\([^:]*\).*/\1/" <<< $DATABASE_URL)
DATABASE_HOST=$(sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" <<< $DATABASE_URL)
DATABASE_PORT=$(sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:]*\)\(:\)\?\([^/]*\)\?.*/\4/" <<< $DATABASE_URL)
case "$DATABASE_ADAPTER" in
  mysql2)
    DATABASE_GEM=mysql
    DATABASE_PORT=${DATABASE_PORT:-3306}
    ;;
  postgres)
    DATABASE_GEM=postgresql
    DATABASE_PORT=${DATABASE_PORT:-5432}
    ;;
esac

fresh_container() {
  [ ! -f $INIT_SEM ]
}

app_present() {
  [ -f /app/config/database.yml ]
}

gems_up_to_date() {
  bundle check 1> /dev/null
}

wait_for_db() {
  db_address=$(getent hosts $DATABASE_HOST | awk '{ print $1 }')
  counter=0
  log "Connecting to $DATABASE_HOST at $db_address"
  while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
    counter=$((counter+1))
    if [ $counter == 30 ]; then
      log "Error: Couldn't connect to $DATABASE_HOST."
      exit 1
    fi
    log "Trying to connect to $DATABASE_HOST at $db_address. Attempt $counter."
    sleep 5
  done
}

setup_db() {
  log "Configuring the database"
  bundle exec rake db:create
}

migrate_db() {
  log "Applying database migrations (db:migrate)"
  bundle exec rake db:migrate
}

log () {
  echo -e "\033[0;33m$(date "+%H:%M:%S")\033[0;37m ==> $1."
}

if ! app_present; then
  log "Creating rails application"
  rails new . --skip-bundle --database $DATABASE_GEM
fi

if ! gems_up_to_date; then
  log "Installing/Updating Rails dependencies (gems)"
  bundle install
  log "Gems updated"
fi

wait_for_db

if ! fresh_container; then
  echo "#########################################################################"
  echo "                                                                       "
  echo " App initialization skipped:"
  echo " Delete the file $INIT_SEM and restart the container to reinitialize"
  echo " You can alternatively run specific commands using docker-compose exec"
  echo " e.g docker-compose exec rails bundle exec rake db:migrate"
  echo "                                                                       "
  echo "#########################################################################"
else
  setup_db
  log "Initialization finished"
  touch $INIT_SEM
fi

migrate_db

exec tini -- "$@"
