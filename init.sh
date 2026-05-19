#!/bin/bash
set -e

# jouw init logic
chown -R www-data:www-data /var/www/html/web/ || true

# daarna: geef alles door aan originele CMD
exec "$@"