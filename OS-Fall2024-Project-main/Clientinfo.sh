#!/bin/bash 

output_file="process_info.log"

# Process tree of all running processes
echo "Process tree of running process: " > "$output_file"
ps aux --forest >> "$output_file"
echo -e "\n" >> "$output_file"

# List of dead or zombie processes
echo "List of dead or zombie process: " >> "$output_file"
ps aux | awk '$8 ~ /Z/ {print $0}' >> "$output_file"
echo -e "\n" >> "$output_file"

# CPU usage of all processes
echo "CPU Usage of all processes: " >> "$output_file"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 20 >> "$output_file"
echo -e "\n" >> "$output_file"

# Memory usage of all processes
echo "Memory Usage of all processes: " >> "$output_file"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 20 >> "$output_file"
echo -e "\n" >> "$output_file"

# Top 5 resource-consuming processes by CPU or memory
echo "Top 5 Resource-Consuming process by (CPU or Memory): " >> "$output_file"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> "$output_file"
echo -e "\n" >> "$output_file"

# Securely copy the file to the remote server
scp -o StrictHostKeyChecking=no "$output_file" server@172.16.85.138:/home/server

# Remove the output file locally
rm "$output_file"
