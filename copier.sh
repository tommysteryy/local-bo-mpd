#!/bin/bash

# Source directory to watch for new files
source_dir="slurm"

# Destination directory to copy new files
destination_dir="$PROJECT_DIR/slurm"

# Start the infinite loop to watch for new files
echo "Watching for changes..."

while true; do
    # Find new files in the source directory
    find "$source_dir" -type f -newermt "$(date -d '1 minute ago')" |
    while read -r file; do
        # Copy the new file to the destination directory
        cp "$file" "$destination_dir"
        echo "Copied $file to $destination_dir"
        echo "Watching for changes..."
    done
    sleep 1m # Wait for 10 seconds before checking again
done