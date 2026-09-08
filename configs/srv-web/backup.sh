#!/bin/bash
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR="/var/backups/web"
mkdir -p $BACKUP_DIR

#wordpress files
tar czf $BACKUP_DIR/www_$DATE.tar.gz /var/www/wanderful.local

#mariadb dump
mysqldump -u wp_user -pWanderful!2026 wordpress_db > $BACKUP_DIR/db_$DATE.sql

#apache config
tar czf $BACKUP_DIR/apache_$DATE.tar.gz /etc/apache2

echo "backup completed!" >> /var/log/backup.log
