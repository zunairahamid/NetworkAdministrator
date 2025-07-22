#!/bin/bash

# Install net-tools if not already installed
sudo apt-get install -y net-tools

# Setting the target IP or hostname
target=$1
current_date=$(date +"%Y-%m-%d %H:%M:%S")

# Performing ping test and logging the result
ping -c 3 -W 5 "$target" && \
    echo "$current_date - Connectivity to $target was successful" | tee -a network.log || {
        echo "$current_date - Connectivity to $target failed" | tee -a network.log
        echo "Running traceroute for $target..." | tee -a network.log
        ./traceroute.sh "$target" | tee -a network.log
    }