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

# Ask user for confirmation before replacing the current 'local-bo-mpd' folder
read -p "Do you want to replace the current 'local-bo-mpd' folder? (y/n): " answer
if [[ $answer == "y" ]]; then
    # Copy everything in the current folder to /scratch/arc/local-bo-mpd
    rm -rf $SCRATCH_DIR/local-bo-mpd
    mkdir -p $SCRATCH_DIR/local-bo-mpd
    cp -f -r . $SCRATCH_DIR/local-bo-mpd
    echo "Everything in the current folder has been copied to $SCRATCH_DIR/local-bo-mpd"
else
    echo "$SCRATCH_DIR/local-bo-mpd has not been changed."
fi

# # Transfer the file to /scratch/arc
cp -f "$file_name" $SCRATCH_DIR

echo "$file_name is transferred to $SCRATCH_DIR for running."

# copy copier.sh to $SCRATCH_DIR/slurm
cp -f copier.sh $SCRATCH_DIR
chmod +x $SCRATCH_DIR/copier.sh

echo "File copier.sh transferred to $SCRATCH_DIR"

echo "Open a new terminal and cd to $SCRATCH_DIR to run the copier.sh script, if you want SLURM output files to be copied to the current folder live."

read -p "Press Enter to continue..."

cd $SCRATCH_DIR
sbatch $file_name