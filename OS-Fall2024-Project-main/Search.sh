#!/bin/bash

temp_file="temp_bigfile"
output_file="bigfile"

find $HOME -type f -size +1M > "$temp_file" 

echo "Search date: $(date)">>"$output_file"

file_count=$(wc -l "$temp_file")
echo "Number of files found larger than 1MB: $file_count" >> "$output_file"

cat "$temp_file" >> "$output_file"
rm "$temp_file"

if [ -s "$output_file" ]; then
    echo -e "Subject: Files found larger than 1 MB\n\nHello,\n\nThe following files larger than 1 MB were found in user account $(whoami):\n\n$(cat "$output_file")\n\nRegards,\nYour Script" | msmtp aa2005623@qu.edu.qa
fi

