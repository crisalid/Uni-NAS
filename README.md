# Uni-nas
SMB Share Monitor and Configuration Script

(A script to maintain SMB share settings on UDM SE, UDM PRO and similar Linux-based products)
## Problem Statement
UDM Pro/SE includes Network Video Recorder (NVR) capabilities and a place for an 8 TB disk, primarily used for storing CCTV video recordings. This NVR runs on a Debian-based system, which provides the capability to set up a Samba (SMB) share that could be mounted on other devices for additional uses beyond CCTV storage. However, there is a critical issue: each time the NVR's software is updated, the SMB configuration is reset to defaults, leading to a loss of the SMB share setup. Consequently, the SMB share needs to be manually reconfigured after every update to restore connectivity. The objective is to create an automated solution that monitors the SMB share's availability, detects when it goes offline (typically indicating a software update), and then re-applies the SMB configuration without manual intervention, thus maintaining persistent access to the SMB share across updates.

## Overview
This project provides a Bash script designed to monitor the accessibility of SMB shares on a Linux system and ensure their configuration is correct. It's particularly useful in environments where SMB shares are critical to operations and need to be reliably available. The script checks for the existence of specific SMB share configurations in /etc/samba/smb.conf and recreates them if they are missing, ensuring both Public and Protected shares are correctly set up for designated user groups.

## Features
- Automated Monitoring: Continuously checks the SMB share configurations for correctness.
- Self-Repair: Automatically recreates the SMB configuration if it detects missing or incorrect settings.
- Security Focused: Ensures that only designated users and groups have access to specific shares.
- Logging: Records all actions taken to restore configurations, aiding in troubleshooting and audit trails.

  
# Getting Started

## Prerequisites
- A Linux system.
- Root or sudo privileges.

## Create Necessary Users and Groups
```console
sudo groupadd publicgrp
sudo groupadd protectedgrp
```

## Create users and add them to their respective groups
```console
sudo useradd Alice -M -G publicgrp
sudo useradd Bob -M -G protectedgrp
```

## Set passwords for users
```console
sudo smbpasswd -a Alice
sudo smbpasswd -a Bob

```

## Navigate to the directory containing the script and make it executable:
```console
cd path/to/script
sudo chmod +x smbdfornvr.sh

```
