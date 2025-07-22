#!/bin/bash

# Here, we are creating the log file disk_info.log to display the detailed disk information.
printf "\n ---> We will display the detailed disk information of the HOME directory.\n" > disk_info.log

# Next, we will append the information about the disk space to the log file disk_info.log.
printf " ---> Now let us display the information related to the disk space.\n\n" >> disk_info.log

# We will used the df -h $HOME to append the info about disk space into disk_info.log
# df (command used to display info about disk usage and information related to it)
# -h (option used to convert the sizes of the file systems into human readable form)
# $HOME (it is a variable that will redirect you to the user's HOME directory)
df -h $HOME >> disk_info.log

# Display the information about the disk usage for the directories
# and append to disk_info.log

printf "\n ---> This is information related to the disk usage for the directories in the HOME directory.\n\n" >> disk_info.log
printf "Size\tDirectory\n" >> disk_info.log

# du (command used to display information about the disk usage for directories and files)
# -h (option used to convert the sizes of the file systems into human readable form)
# $HOME (it is a variable that will redirect you to the user's HOME directory - In this case we are printing the disk usage for HOME directories)
du -h $HOME/* >> disk_info.log

printf "\n ---> This is information related to the disk usage for the subdirectories in the HOME directory.\n\n" >> disk_info.log
printf "Size\tSub-Directory\n" >> disk_info.log

# du (command used to display information about the disk usage for directories and files)
# -h (option used to convert the sizes of the file systems into human readable form)
# $HOME (it is a variable that will redirect you to the user's HOME directory - In this case we are printing the disk usage for HOME subdirectories)
du -h $HOME/*/* >> disk_info.log

# Display the information stored in the log file disk_info.log
cat disk_info.log

# Here, we are creating the log file mem_cpu_info.log to display the detailed the memory percentages for used and free memory.
# Additionally, we will be adding information about the CPU Model and the number of CPU cores.
printf "\n ---> Now, we will display the information about the memory and CPU.\n\n" > mem_cpu_info.log

# Next, we will append the memory information to the log file mem_cpu_info.log.

# The following code will allow you store the value for the total memory in the total_memory variable, used memory in the used_memory variable, etc.
# free -m is a command that will allow us to display the total, used, free memory, etc in MB.
# awk is a command that will allow us to extract specific text (text processing tool).
# NR == 2 means that we are ignoring the header and we look at the second row (the memory data we are concerned with is contained here).
# print $2 will allow us to extract the second column which corresponds to the total memory. 
# print $3 will allow us to extract the third column which corresponds to the used memory.
# print $4 will allow us to extract the fourth column which corresponds to the free memory. 

total_memory=$(free -m | awk 'NR == 2 {print $2}') 
free_memory=$(free -m | awk 'NR == 2 {print $4}') 
used_memory=$(free -m | awk 'NR == 2 {print $3}')

# Here, we are calculating the free and used memory percentages. 
# echo will allow us to send whatever is inside it (here it is the calculation) as an input to bc. This happens through a pipe.
# bc is a basic calculator that will perform the calculation and will give the answer to four decimal places (due to us using scale=4).
# The answer will then be stored in the variables free_memory_percentage and used_memory_percentage.

free_memory_percentage=$(echo "scale=4; ($free_memory/$total_memory) * 100" | bc)
used_memory_percentage=$(echo "scale=4; ($used_memory/$total_memory) * 100" | bc)

# Next, we will append the free and used memory percentages to the log file mem_cpu_info.log.

printf "This is the free memory percentage: $free_memory_percentage percent.\n" >> mem_cpu_info.log
printf "This is the used memory percentage: $used_memory_percentage percent.\n\n" >> mem_cpu_info.log

# Next, let us display information about the CPU Model and the number of CPU cores

# The following code allows us to store the CPU model name in the variable CPU_model_name, CPU model in the variable CPU_model, etc.
# For CPU_model_name, we first use the command lscpu (display information about the CPU) that will be an input for the command grep (this occurs through a pipe).
# Next, the grep command will search for the line that contains Model name.
# Once it finds the line, it will go through another pipe.
# awk -F: just takes the line and separates it using the colon and then extracts the second column.
# Lastly, we will use xargs to remove any unnecessary whitespace.
 
# We do a similar task for the CPU model and no of CPU cores.
# grep '^Model:' just finds a line that starts with Model: and then we extract the second column.
# grep '^CPU(s)' just finds a line that starts with CPU(s): and then we extract the second column. 

CPU_model_name=$(lscpu | grep 'Model name' | awk -F: '{print $2}'| xargs)
CPU_model=$(lscpu | grep '^Model:' | awk '{print $2}') 
No_CPU_cores=$(lscpu | grep '^CPU(s)' | awk '{print $2}')

printf "This is the CPU Model Name: $CPU_model_name.\n" >> mem_cpu_info.log
printf "This is the CPU Model: $CPU_model.\n" >> mem_cpu_info.log
printf "This is the number of CPU cores: $No_CPU_cores.\n" >> mem_cpu_info.log

# Display the information stored in the log file mem_cpu_info.log
cat mem_cpu_info.log


