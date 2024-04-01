# uni-nas
SMB Share Monitor and Configuration Script

(A script to maintain SMB share settings on UDM SE, UDM PRO and similar Linux-based products)

## Overview
This project provides a Bash script designed to monitor the accessibility of SMB shares on a Linux system and ensure their configuration is correct. It's particularly useful in environments where SMB shares are critical to operations and need to be reliably available. The script checks for the existence of specific SMB share configurations in /etc/samba/smb.conf and recreates them if they are missing, ensuring both Public and Protected shares are correctly set up for designated user groups.

## Why This Script?
Some vendors, like Ubiquity, provide device updates leading to SMB configuration reset.
In many networked environments, SMB shares are essential for file sharing among users and systems. However, configurations can become corrupted or altered, leading to downtime and access issues. This script automates the monitoring and maintenance of SMB share configurations, reducing the need for manual checks and fixes, and ensuring continuous availability of critical network resources.

## Features
- Automated Monitoring: Continuously checks the SMB share configurations for correctness.
- Self-Repair: Automatically recreates the SMB configuration if it detects missing or incorrect settings.
- Security Focused: Ensures that only designated users and groups have access to specific shares.
- Logging: Records all actions taken to restore configurations, aiding in troubleshooting and audit trails.
#Getting Started
### Prerequisites
A Linux system with Samba installed.
Root or sudo privileges.
