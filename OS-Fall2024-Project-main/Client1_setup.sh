#!/bin/bash

#Verify the installation of SSH
if ssh -V > /dev/null 2>&1; then
    echo "SSH Already installed"
else
    sudo apt-get update
    sudo apt-get install -y openssh-client
    echo "SSH is installed."
fi

#Enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh
echo "SSH is enabled."

#Verify the installation of SFTP
if command -v sftp > /dev/null 2>&1; then
    echo "SFTP Already Installed"
else
    sudo apt-get install -y openssh-client
    echo "SFTP is installed."
fi

#Verify SCP availablitiy
if command -v scp > /dev/null 2>&1; then
    echo "SCP Already Available"
else
    sudo apt-get install -y openssh-client
    echo "SCP is installed."
fi

echo "Client setup complete."

#Configure SSH and SFTP
echo "Configuring SSH and SFTP..."
#Ensure local user accounts created on the server match the credentials for client access
read -p "Enter the IP address of the Server: " serverIP
read -p "Enter the username on the Server: " serverUsername

#Test connection
ssh -o BatchMode=yes -o ConnectionTimeout=5 "$serverUsername@$serverIP" exit
if [ $? -eq 0 ]; then
    echo "$serverIP is successfully connected"
else
    echo "$serverIP failed to connect." 
fi

#Set up SFTP and SCP
sftp "$serverUsername@$serverIP" <<EOF
bye
EOF

if [ $? -eq 0 ]; then
    echo "Succecful SFTP set up"
else
    echo "failed to set up." 
fi

echo "SSH and SFTP are configured."
