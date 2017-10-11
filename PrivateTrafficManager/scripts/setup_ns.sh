#!/bin/bash

sql_server_password=$1

debconf-set-selections <<< "mysql-server mysql-server/root_password $sql_server_password password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again $sql_server_password verify_password"

debconf-set-selections <<< "pdns-backend-mysql pdns-backend-mysql/password-confirm $sql_server_password password"
debconf-set-selections <<< "pdns-backend-mysql  pdns-backend-mysql/app-password-confirm $sql_server_password password"
debconf-set-selections <<< "pdns-backend-mysql  pdns-backend-mysql/mysql/app-pass $sql_server_password password"
debconf-set-selections <<< "pdns-backend-mysql   pdns-backend-mysql/mysql/admin-pass $sql_server_password password"

apt-get update 
apt-get -y install mysql-server mysql-client  pdns-server pdns-backend-mysql pdns-server pdns-backend-remote