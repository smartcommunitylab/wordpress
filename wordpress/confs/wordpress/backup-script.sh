#!/usr/bin/env bash

NOW=$(date +%Y%m%d-%H%M%S) 
RND=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)
echo "Enable maintenance-mode"
wp maintenance-mode activate

echo "Database backup in progress.."
wp db export --single-transaction "/mnt/backup-dir/${WORDPRESS_TITLE}-${NOW}-${RND}.sql"
tar -vczf "/mnt/backup-dir/${WORDPRESS_TITLE}-${NOW}-${RND}-db.tar.gz" "."
echo "Database backup in complete.."
echo "Wordpress backup in progress.."
tar -vczf "/mnt/backup-dir/${WORDPRESS_TITLE}-${NOW}-${RND}-site.tar.gz" "."
echo "Wordpress backup in complete.."

echo "Disable maintenance-mode"
wp maintenance-mode deactivate
