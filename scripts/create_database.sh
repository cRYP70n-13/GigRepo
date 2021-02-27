#!/bin/bash

# start Mariadb server
service mysql start

# Create the new user and grant access to it
mysql -uroot -e "GRANT SELECT, INSERT, UPDATE, DELETE ON litecartdb.* TO 'admin'@'localhost' IDENTIFIED BY 'admin';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'admin' WITH GRANT OPTION;"

# Create the litecartdb and give access to cRYP70n to it
mysql -uroot -e "CREATE DATABASE litecartdb;"
mysql -uroot -e "GRANT ALL ON litecartdb.* TO 'admin'@'localhost' IDENTIFIED BY 'admin';"
