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
apt-get -y install mysql-server mysql-client  pdns-server pdns-backend-mysql pdns-server pdns-backend-remote memcached python3-pip

#Add recurser to Azure DNS
sudo sed -i.bak 's/# recursor=no/recurser=168.63.129.16/' /etc/powerdns/pdns.conf

#Install polaris
git clone https://github.com/polaris-gslb/polaris-gslb.git
cd polaris-gslb
sudo python3 setup.py install

wget https://raw.githubusercontent.com/hansenms/PrivateTrafficManager/master/PrivateTrafficManager/scripts/pdns/pdns.local.remote.conf
wget https://raw.githubusercontent.com/hansenms/PrivateTrafficManager/master/PrivateTrafficManager/scripts/polaris/polaris-health.yaml
wget https://raw.githubusercontent.com/hansenms/PrivateTrafficManager/master/PrivateTrafficManager/scripts/polaris/polaris-lb.yaml
wget https://raw.githubusercontent.com/hansenms/PrivateTrafficManager/master/PrivateTrafficManager/scripts/polaris/polaris-pdns.yaml
wget https://raw.githubusercontent.com/hansenms/PrivateTrafficManager/master/PrivateTrafficManager/scripts/polaris/polaris-topology.yaml

cp pdns.local.remote.conf /etc/powerdns/pdns.d/
cp *.yaml /opt/polaris/etc/
systemctl restart pdns.service
/opt/polaris/bin/polaris-health stop
/opt/polaris/bin/polaris-health start


