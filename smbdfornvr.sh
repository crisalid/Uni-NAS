#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Check if Samba is installed, install if not
if ! command -v smbd &> /dev/null; then
  echo "Samba is not installed. Installing..."
  apt-get update && apt-get install -y samba
  systemctl enable smbd.service
fi

# Path to the Samba configuration file
SMB_CONF="/etc/samba/smb.conf"

# Function to create or recreate SMB configuration for two shares
create_smb_config() {
  echo "Creating or recreating SMB configuration for two shares..."
  # Create a new smb.conf with a basic configuration
  echo "[global]
server min protocol = NT1
security = user
map to guest = bad user
log file = /var/log/samba/%m.log
server string = Samba Server %v
max log size = 50
" > "$SMB_CONF"

  # Add network share configuration for Public
  echo "[Public]
path = /volume1/Samba/Public
valid users = @publicgrp
read only = no
writable = yes
guest ok = no" >> "$SMB_CONF"

  # Add network share configuration for Protected
  echo "[Protected]
path = /volume1/Samba/Protected
valid users = @protectedgrp
read only = no
writable = yes
guest ok = no" >> "$SMB_CONF"
systemctl restart smbd.service
}

# Function to check SMB share accessibility by verifying configuration existence
check_smb_access() {
  # Check for Public and Protected share configurations in smb.conf
  if grep -q "\[Public\]" "$SMB_CONF" && grep -q "\[Protected\]" "$SMB_CONF"; then
    echo "Both Public and Protected share configurations exist."
    return 0
  else
    echo "One or both share configurations are missing."
    return 1
  fi
}

# Ensure the SMB configuration exists with the necessary shares
if [ ! -f "$SMB_CONF" ] || ! check_smb_access; then
  create_smb_config
fi

# Define the shared folder paths
PUBLIC_FOLDER="/volume1/Samba/Public"
PROTECTED_FOLDER="/volume1/Samba/Protected"

# Ensure the shared folders exist and have correct permissions
for folder in "$PUBLIC_FOLDER" "$PROTECTED_FOLDER"; do
  if [ ! -d "$folder" ]; then
    echo "Creating shared folder: $folder"
    mkdir -p "$folder"
  fi
  chmod -R 775 "$folder"
done

# Set ownership for the folders to their respective groups
chown -R :publicgrp "$PUBLIC_FOLDER"
chown -R :protectedgrp "$PROTECTED_FOLDER"

# Function to restore SMB configuration and restart service
restore_smb_config() {
  create_smb_config

  # Restart Samba service
  systemctl restart smbd.service

  # Log success
  echo "$(date) - Successfully recreated SMB share configurations for Public and Protected" >> /var/log/smb_monitor.log
}

# Main loop to monitor SMB share every minute
while true; do
  if ! check_smb_access; then
    echo "One or both SMB shares are offline. Recreating configuration..."
    restore_smb_config
  fi
  sleep 60
done
