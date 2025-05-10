#!/bin/bash

# Run .release.sh only if it exists
if [ -f ".release.sh" ]; then
  sh .release.sh
fi

# Then exec the container's main process (e.g., Supervisord)
exec "$@"