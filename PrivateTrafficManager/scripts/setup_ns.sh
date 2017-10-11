#!/bin/bash

sql_server_password=$1

debconf-set-selections <<< "mysql-server mysql-server/root_password password $sql_server_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $sql_server_password"

debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/password-confirm password $sql_server_password"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/app-password-confirm password $sql_server_password"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/mysql/app-pass password $sql_server_password"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/mysql/admin-pass password $sql_server_password"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/dbconfig-remove select true"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/dbconfig-reinstall select false"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/dbconfig-upgrade select true"
debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/dbconfig-install select true"

apt-get update 
apt-get -y install mysql-server mysql-client  pdns-server pdns-backend-mysql pdns-server pdns-backend-remote
