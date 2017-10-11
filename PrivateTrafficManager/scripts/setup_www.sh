#!/bin/bash

machine_message="<html><h1>Machine: $(hostname)</h1></html>"

apt-get update
apt-get -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get -y install docker-ce

mkdir -p /var/www
echo $machine_message >> /var/www/index.html
docker run --detach --restart unless-stopped -p 80:80 --name nginx1 -v /var/www:/usr/share/nginx/html:ro -d nginx