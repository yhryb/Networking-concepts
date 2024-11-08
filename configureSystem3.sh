#!/bin/bash

#install apache
sudo apt update
sudo apt install -y apache2 iptables socat

#listen on port 1000 not 80
sudo sed -i 's/Listen 80/Listen 10000/' /etc/apache2/ports.conf
sudo systemctl restart apache2

#restrict access to port 10000
sudo iptables -A INPUT -p tcp --dport 10000 -s 127.0.0.1 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 10000 -j DROP

#copy html files
sudo cp index.html error.html /var/www/html/

#deploy files
sudo cp proxyServer.sh /etc/
sudo cp proxyServer.service /etc/systemd/system/

#enable and start proxyServer service
sudo systemctl daemon-reload
sudo systemctl enable proxyServer
sudo systemctl start proxyServer
