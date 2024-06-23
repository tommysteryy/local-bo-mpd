#!/bin/bash

# Source directory to watch for new files
source_dir="/path/to/source/directory"

# Destination directory to copy new files
destination_dir="/path/to/destination/directory"

# Start the infinite loop to watch for new files
while true; do
    # Find new files in the source directory
    find "$source_dir" -type f -newermt "$(date -d '1 minute ago')" |
    while read -r file; do
        # Copy the new file to the destination directory
        cp "$file" "$destination_dir"
        echo "Copied $file to $destination_dir"
    done
    sleep 1m # Wait for 1 minute before checking again
done