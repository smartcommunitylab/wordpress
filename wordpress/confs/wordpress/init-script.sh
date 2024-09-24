#!/usr/bin/env bash

dbName="${WORDPRESS_DB_NAME}"
dbUser="${WORDPRESS_DB_USER}"
dbPass="${WORDPRESS_DB_PASSWORD}"
dbPrefix="${WORDPRESS_TABLE_PREFIX}"
dbHost="${WORDPRESS_DB_HOST}"

wpUrl="${WORDPRESS_URL}"
wpTitle="${WORDPRESS_TITLE}"
wpAdminUsername="${WORDPRESS_ADMIN_USERNAME}"
wpAdminPassword="${WORDPRESS_ADMIN_PASSWORD}"
wpAdminEmail="${WORDPRESS_ADMIN_EMAIL}"

echo "Create wp-config.php"
wp config create --dbname="$dbName" --dbuser="$dbUser" --dbpass="$dbPass" --dbhost="$dbHost" --dbprefix="$dbPrefix" --path=/var/www/html/

echo "Wait until db is ready"
while true; do
  wp db check --path=/var/www/html/
  if [ $? -eq 0 ]; then
    break
  fi
  echo "DB is not ready, retry in 10 seconds" 
  sleep 10
done

echo "Check if wordpress is installed"
if ! wp core is-installed 2>/dev/null; then
  echo "WP is not installed. Let's try installing it."
  wp core install --url="$wpUrl" --title="$wpTitle" --admin_user="$wpAdminUsername" --admin_email="$wpAdminEmail" --skip-email --admin_password="$wpAdminPassword" --path=/var/www/html/
fi
