#!/bin/bash

# Check if script is run as root (required for installing packages and system-wide configuration)
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install required packages
echo "Installing required packages..."
apt update
apt install -y socat

# Copy the apiServer.sh script to /usr/bin and make it executable
echo "Configuring apiServer.sh..."
cp apiServer.sh /usr/bin/apiServer.sh
chmod +x /usr/bin/apiServer.sh

# Set up logging directory and log file
LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/apiServer.log"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Copy the systemd service file to the system directory
echo "Setting up systemd service..."
cp apiService.service /etc/systemd/system/apiService.service

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable and start the apiService service
echo "Enabling and starting the apiService service..."
systemctl enable apiService
systemctl start apiService

# Confirm if the service is active
if systemctl is-active --quiet apiService; then
    echo "apiService is running successfully."
else
    echo "apiService failed to start. Check /var/log/syslog for details."
    exit 1
fi

echo "Server setup is complete."
