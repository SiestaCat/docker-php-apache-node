#!/bin/bash

echo "==== ENTRYPOINT docker-php-apache-node ===="

# Run .release.sh only if it exists
if [ -f ".release.sh" ]; then
  sh .release.sh
fi

service cron start

if [ -f /var/www/html/.crontab.prod.txt ]; then
  echo "Loading crontab for www-data from .crontab.prod.txt"
  crontab -u www-data /var/www/html/.crontab.prod.txt
else
  echo "Could not find .crontab.prod.txt; skipping crontab installation"
fi

# Then exec the container's main process (e.g., Supervisord)
exec "$@"