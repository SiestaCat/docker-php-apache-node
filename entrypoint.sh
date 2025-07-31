#!/bin/bash

# Run .release.sh only if it exists
if [ -f ".release.sh" ]; then
  sh .release.sh
fi

service cron start

if [ -f /var/www/html/.crontab.prod.txt ]; then
  echo "Cargando crontab de www-data desde .crontab.prod.txt"
  crontab -u www-data /var/www/html/.crontab.prod.txt
else
  echo "No se encontró .crontab.prod.txt; omitiendo instalación de crontab"
fi

# Then exec the container's main process (e.g., Supervisord)
exec "$@"