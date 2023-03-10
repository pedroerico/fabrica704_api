#!/bin/bash
set -e

#
mkdir -p /var/www

rm /var/www/var/*.db || true

composer i -o

php /var/www/bin/console cache:clear

php /var/www/bin/console doctrine:database:create --if-not-exists --no-interaction

php /var/www/bin/console --env=test doctrine:database:create

php /var/www/bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

php /var/www/bin/console --env=test doctrine:schema:create --no-interaction

php /var/www/bin/console lexik:jwt:generate-keypair --skip-if-exists --no-interaction

chmod -R o+s+w /var/www

service supervisor start

exec "$@"
