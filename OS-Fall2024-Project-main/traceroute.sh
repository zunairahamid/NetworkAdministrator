#!/bin/bash
target=$1
current_date=$(date +"%Y-%m-%d %H:%M:%S")

# Display routing table
echo "Executing routing table check..."
echo "$current_date - Routing table:" >> network.log
route -n >> network.log

# Display hostname
echo "Executing hostname check..."
echo "$current_date - Hostname:" >> network.log
hostname >> network.log

# Test DNS resolution for google.com
echo "Executing DNS resolution check..."
echo "$current_date - Testing DNS resolution for google.com:" >> network.log
nslookup google.com >> network.log

# Trace route to the target
echo "Executing traceroute to $target..."
echo "$current_date - Tracing route to $target:" >> network.log
traceroute "$target" >> network.log

# Ping Google to check external connectivity
echo "Executing ping to google.com..."
echo "$current_date - Pinging google.com to check external connectivity:" >> network.log
ping -c 3 google.com >> network.log

# Reboot if required
echo "Checking if reboot is necessary..."
echo "$current_date - Target $target is unreachable. Rebooting the system." >> network.log
sudo reboot