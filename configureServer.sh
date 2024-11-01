#!/bin/bash

# Install socat if not installed
if ! command -v socat &> /dev/null; then
  sudo apt update
  sudo apt install -y socat
fi

# Create necessary directories
sudo mkdir -p /etc/apiServer
sudo mkdir -p /var/log/apiServer

# Move db.txt to the appropriate directory
sudo cp db.txt /etc/apiServer/db.txt
sudo chmod 644 /etc/apiServer/db.txt

# Move and enable the service file
sudo cp apiService.service /etc/systemd/system/apiService.service
sudo systemctl daemon-reload
sudo systemctl enable apiService.service
sudo systemctl start apiService.service
echo "Server configured and started."
