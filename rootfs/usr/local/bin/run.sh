#!/bin/sh

# Set configurations
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/php.ini
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/sites-enabled/snappymail.conf
sed -i "s/<SERVER_NAME>/$SERVER_NAME/g" /etc/nginx/sites-enabled/snappymail.conf
sed -i "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /etc/php/7.4/fpm/php.ini

# Copy php.ini
# cat /php.ini > /etc/php/7.4/fpm/php.ini

# Add folders
# mkdir -p /rainloop/data/_data_/_default_/plugins/
# mkdir -p /var/log/rainloop

# Fix permissions
usermod -u $UID www-data
groupmod -g $GID www-data
chown -R $UID:$GID /usr/share/snappymail/
chown -R $UID:$GID /var/lib/snappymail
chmod 755 /logs
chown -R $UID:$GID /logs

exec "$@"
