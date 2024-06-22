#!/bin/bash

# Check if the file name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide a file name as an argument."
    exit 1
fi

# Get the file name from the argument
file_name=$1

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "File '$file_name' does not exist."
    exit 1
fi

# Transfer the file to /scratch/arc
cp "$file_name" $SCRATCH_DIR

echo "File '$file_name' transferred to $SCRATCH_DIR"

cd $SCRATCH_DIR

sbatch $file_name