#!/bin/bash

# start Mariadb server
service mysql start

# Create the new user and grant access to it
mysql -uroot -e "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'pmapass';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'cRYP70N'@'localhost' IDENTIFIED BY 'cRYP70N' WITH GRANT OPTION;"

# Create the litecartdb and give access to cRYP70n to it
mysql -uroot -e "CREATE DATABASE litecartdb;"
mysql -uroot -e "GRANT ALL ON litecartdb.* TO 'cRYP70N'@'localhost' IDENTIFIED BY 'cRYP70N';"
