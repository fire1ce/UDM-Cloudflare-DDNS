#!/bin/bash

# Define the DDNS service and timer names
DDNS_SERVICE_NAME="cloudflare-ddns-update"

echo "Starting the uninstallation of Cloudflare DDNS service..."

# Extract DATA_DIR from the service file
SERVICE_FILE="/etc/systemd/system/$DDNS_SERVICE_NAME.service"
if [ -f "$SERVICE_FILE" ]; then
  DATA_DIR=$(grep 'ExecStart=' "$SERVICE_FILE" | cut -d= -f2 | xargs dirname)
else
  echo "Service file not found. Cannot determine DATA_DIR automatically."
  exit 1
fi

echo "Identified DATA_DIR as $DATA_DIR"

# Stop the systemd service and timer
echo "Stopping DDNS service and timer..."
systemctl stop "$DDNS_SERVICE_NAME.service"
systemctl stop "$DDNS_SERVICE_NAME.timer"

# Disable the systemd service and timer
echo "Disabling DDNS service and timer..."
systemctl disable "$DDNS_SERVICE_NAME.service"
systemctl disable "$DDNS_SERVICE_NAME.timer"

# Remove the systemd service and timer files
echo "Removing DDNS service and timer files..."
rm -f "/etc/systemd/system/$DDNS_SERVICE_NAME.service"
rm -f "/etc/systemd/system/$DDNS_SERVICE_NAME.timer"

# Reload systemd to apply changes
systemctl daemon-reload

# Remove the DDNS script and configuration files
echo "Removing DDNS script and configuration files..."
rm -rf "$DATA_DIR"

echo "Cloudflare DDNS service has been successfully uninstalled."
exit 0
