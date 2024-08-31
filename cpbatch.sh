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

# Copy everything in current folder to /scratch/arc
mkdir -p $SCRATCH_DIR/local-bo-mpd
cp -r . $SCRATCH_DIR/local-bo-mpd

# # Transfer the file to /scratch/arc
# cp "$file_name" $SCRATCH_DIR

echo "Everything is transferred to $SCRATCH_DIR"

# copy copier.sh to $SCRATCH_DIR/slurm
cp copier.sh $SCRATCH_DIR
chmod +x $SCRATCH_DIR/copier.sh

echo "File copier.sh transferred to $SCRATCH_DIR"

echo "Open a new terminal and cd to $SCRATCH_DIR to run the copier.sh script"

read -p "Press Enter to continue..."

cd $SCRATCH_DIR
sbatch $file_name