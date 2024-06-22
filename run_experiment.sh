#!/bin/bash
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0:05:00  
#SBATCH --account=st-gpleiss-1
#SBATCH --mail-user=txu25@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=first_run
#SBATCH -e $PROJECT_DIR/slurm/errors/s-%j.err    # Specify the error file. The %j will be replaced by the Slurm job id.
#SBATCH -o $PROJECT_DIR/slurm/output/s-%j.out      # Specify the output file

source ~/.bashrc

cd $PROJECT_DIR

conda activate mpd

echo "Success"

conda deactivate