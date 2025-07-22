#!/bin/bash

# Define the log file where permission changes will be recorded
Log_File="perm_change.log"

# If there is data that exists in this file, clear it, if the file does not exist, create new file.
> "$Log_File"

# Find all files with permission 777
find / -type f -perm 0777 2>/dev/null | while read -r file; do
	# Display the path of the files with 777 if found
	echo "Sucess! Found file with 777 permissions: $file"

	# Log the path of the files found and its current permissions
	echo "Changing permissions for: $file" >> "$Log_File"
	
	# Change the files permissions to 700
	chmod 700 "$file"

	# Log the (new) permissions of the file
	echo "$file permission has been changed to 700" >> "log_File"
done

# Print a message at the end to indicate that all permission changes have been completed and is saved to the log file
echo "All permission changes have been completed! The changes made have been logged in $Log_File."
