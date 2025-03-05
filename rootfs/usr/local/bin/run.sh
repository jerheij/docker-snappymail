#!/bin/sh

# Set configurations
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /php.ini
sed -i "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/sites-enabled/snappymail.conf
sed -i "s/<SERVER_NAME>/$SERVER_NAME/g" /etc/nginx/sites-enabled/snappymail.conf
if [ ! -z $CLIENT_CERT ]
then
  sed -i "s/<CLIENT_CERT>/$CLIENT_CERT/g" /etc/nginx/sites-enabled/snappymail.conf
elif [ -z $CLIENT_CERT ]
then
  sed -i "/ssl_verify_client/d" /etc/nginx/sites-enabled/snappymail.conf
  sed -i "/ssl_client_certificate/d" /etc/nginx/sites-enabled/snappymail.conf
fi
sed -i "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php.ini

# Copy php.ini
cat /php.ini > /etc/php/8.1/fpm/php.ini

# Fix permissions
usermod -u $UID www-data
groupmod -g $GID www-data
chown -R $UID:$GID /usr/share/snappymail/
chown -R $UID:$GID /var/lib/snappymail
chmod 755 /logs
chown -R $UID:$GID /logs

exec "$@"
