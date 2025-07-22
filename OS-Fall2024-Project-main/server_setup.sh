#!/bin/bash

# local user accounts for client1 and client2
echo "Creating local user accounts..."
sudo useradd -m client1
echo "client1:Client1@1" | sudo chpasswd
sudo useradd -m client2
echo "client2:Client2@2" | sudo chpasswd

# Install and enable SSHD
echo "Installing and enabling SSHD..."
sudo apt-get update
sudo apt-get install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Configure SSH and SFTP
echo "Configuring SSH and SFTP..."
# Ensure the SSH configuration file allows password authentication and SFTP access
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#Subsystem sftp/Subsystem sftp/' /etc/ssh/sshd_config

# Restart the SSH service to apply changes
sudo systemctl restart ssh

# Test SSH access for the new users
echo "Testing SSH access for client1 and client2..."
ssh -o StrictHostKeyChecking=no client1@localhost "echo 'SSH access for client1 is working'"
ssh -o StrictHostKeyChecking=no client2@localhost "echo 'SSH access for client2 is working'"

# Set up SCP for file transfers
# it is already setup by default therefore no commands are needed.

echo "Server setup complete. SSH and SFTP are configured for client1 and client2."
