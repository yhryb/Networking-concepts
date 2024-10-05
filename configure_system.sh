#!/bin/bash
echo "Starting vm"
multipass start Assignment1
multipass shell Assignment1

echo "Installing the A3 packages"
sudo apt update -y
sudo apt install -y nat-traverse
sudo apt install -y bmon
#use -y to automatically say yes

echo "Creating the directory"
sudo mkdir -p /usr/lib/mister/postman

echo "Creating the file" 
sudo touch /usr/lib/mister/postman/config.json

echo "Copying simpleService.sh to /etc"
sudo cp ./simpleService.sh /etc/simpleService.sh
sudo chmod +x /etc/simpleService.sh  
#chmod makes it executable

echo "Copying simpleService.service to the etc directory"
sudo cp ./simpleService.service /etc/systemd/system/simpleService.service
sudo systemctl daemon-reload
#let systemd know about the simpleService.service, daemon-reload refreshes systemd
sudo systemctl enable simpleService.service 
#enable to run at the start of the system


