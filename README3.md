# Networking Concepts - Assignment 3

## Description

The assignment is about filtering traffic with iptables, creating a proxy server that decides on which hmtl page will be shown based on predetermined calculations, and configuring an apache file to run on another port.

## Files

1. **index.html**: html for success.
2. **error.html**: hmtl for failure.
3. **proxyServer.sh**: calculations; file choosing.
4. **proxyServer.service**: the `systemd` service file that starts the `proxyServer.sh` on system boot after Apache2 service.
5. **configureSystem.sh**: commands.
6. **README.md**: description.

## Installation Instructions

### 1. Set up Apache2 to run on port 10000
- Apache2 should be configured to listen on port `10000`. This configuration is done by modifying the `/etc/apache2/ports.conf` and `/etc/apache2/sites-enabled/000-default.conf` files.

### 2. Restrict port access using `iptables`
- Use `iptables` to restrict access to port `10000` to only local requests.

### 3. Setting up the Proxy Server

The `proxyServer.sh` script is responsible for returning either the `index.html` or `error.html` based on the conditions set in your assignment's variant.

### 4. Create and Install Systemd Service

The service `proxyServer.service` ensures that the proxy server is started after the Apache2 service on boot. It uses `socat` to listen on port 80 and forward requests to the `proxyServer.sh` script.

### 5. Deploy the HTML Files
Place the `index.html` and `error.html` files in the `/var/www/html` directory. These files are displayed by the proxy server.

### 6. Run the Configuration Script

You can automate the installation process by running the `configureSystem.sh` script, which installs all the necessary components and configurations.

---

## Instructions for Running the Setup

1. **Download the project files.**
2. **Run the configuration script**:

```bash
sudo bash configureSystem.sh
