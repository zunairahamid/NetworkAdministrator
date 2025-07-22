#!/bin/bash

# Configurable variables
log_file="invalid_attempts.log"      # Log file to store login attempts
maxAttempts=3                        # Maximum number of login attempts
attempts=0                           # Counter for the number of attempts
serverIP="172.16.85.138"             # Set the server IP directly

# Ask the user for username and password
read -p "Enter username: " user
read -s -p "Enter password: " password
echo    # Move to a new line after password input for better readability

# Function to attempt SSH login using sshpass
login_attempt() {
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$user@$serverIP" exit 2>/dev/null
}

# Function to transfer log file using SFTP
transfer_log() {
    sshpass -p "$password" sftp -o StrictHostKeyChecking=no "$user@$serverIP" <<EOF
    put $log_file
    bye
EOF
}

# Main loop to handle login attempts
while [ $attempts -lt $maxAttempts ]; do
    echo "Attempting to connect to $serverIP with username $user."
    
    # Attempt to log in and check if successful
    if login_attempt; then
        echo "Successful login"
        exit 0
    else
        echo "Invalid login attempt for $user on $(date)" | tee -a "$log_file"
        echo "Invalid credentials. Please try again!"
        ((attempts++))
    fi
done

# If maximum attempts are reached
echo "Unauthorized user!"
echo "Maximum attempts reached for $user on $(date)" | tee -a "$log_file"

# Transfer the log file to the server using SFTP
echo "Transferring log file to the server..."
transfer_log

# Logging out in 30 seconds
echo "Logging out in 30 seconds..."
sleep 30
pkill -KILL -u "$USER"  # Logs out the user if they have reached maximum attempts
