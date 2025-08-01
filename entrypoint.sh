#!/bin/bash

echo "==== ENTRYPOINT docker-php-apache-node ===="

# Always start cron service
sudo service cron start

# Fix cron startup issue
if ! sudo service cron status >/dev/null 2>&1; then
  sleep 2
  sudo service cron restart
fi

# Only load crontab if APP_ENV is set
if [ ! -z "$APP_ENV" ]; then
  # Load different crontab file based on APP_ENV value
  CRONTAB_FILE="/var/www/html/.crontab.${APP_ENV}.txt"
  
  if [ -f "$CRONTAB_FILE" ]; then
    echo "Loading crontab for www-data from .crontab.${APP_ENV}.txt"
    crontab -u www-data "$CRONTAB_FILE"
  else
    echo "Could not find $CRONTAB_FILE; skipping crontab installation"
  fi
else
  echo "APP_ENV not set; skipping crontab installation"
fi

sleep 2
sudo service cron restart

# Run .release.sh only if it exists
if [ -f ".release.sh" ]; then
  sh .release.sh
fi

# Then exec the container's main process (e.g., Supervisord)
exec "$@"