#!/bin/bash

# Update and install
apt-get update -y
apt-get upgrade -y

# Install Lamp server
apt-get install --no-install-recommends -y apache2 \
      mariadb-server \
      php libapache2-mod-php php-common \
      php-mbstring php-xmlrpc php-soap php-gd php-xml \
      php-intl php-mysql php-cli php-zip php-curl \
      php-soap unzip mlocate systemd

# Start all the packages
service apache2 start
service mariadb start
service apache2 enable
service mariadb enable

# The necessary changes in php.ini file
rm /etc/php/7.3/apache2/php.ini
cp php.ini /etc/php/7.3/apache2/

# Configure MariaDB
# NOTE: Bring the create db here ...

# Download liteCart
wget -qO litecart.zip "https://www.litecart.net/en/downloading?action=get&version=latest"
mkdir /var/www/html/litecart
unzip litecart.zip -d /var/www/html/litecart

# Give proper permissions to the litecart directory
chown -R www-data:www-data /var/www/html/litecart/
chmod -R 755 /var/www/html/litecart/

# Configure apache for litecart
echo "<VirtualHost *:80>
     ServerAdmin admin@example.com
     ServerName example.com
     DocumentRoot /var/www/html/litecart/public_html/

     <Directory /var/www/html/litecart/>
        AllowOverride All
        allow from all
     </Directory>

     ErrorLog /var/log/apache2/litecart_error.log
     CustomLog /var/log/apache2/litecart_access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/litecart.conf

ln -s /etc/apache2/sites-available/litecart.conf /etc/apache2/sites-enabled/litecart.conf

# Enable the litecart virtual host
a2ensite /etc/apache2/sites-available/litecart.conf

# Enable apache header and rewrite the module
a2enmod rewrite
a2enmod headers

# Restart apache2
service apache2 restart

# We can verify if it works or not
# just by using systemctl status apache2
