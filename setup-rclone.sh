#!/bin/bash
# All these items are executed as root

# Set the user and groups
USER=felix
GROUP=felix

apt -y install unzip curl fuse libfuse-dev

# Standard rclone install
curl https://rclone.org/install.sh | sudo bash

# Update fuse.conf with the allow other

echo "user_allow_other" >> /etc/fuse.conf

# Create directories for my mounts

mkdir /GD
mkdir /gmedia

# Fix user/group and chmod
chown $USER:$GROUP /GD /gmedia
chmod 775 /GD /gmedia


