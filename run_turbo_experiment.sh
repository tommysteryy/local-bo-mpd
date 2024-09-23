#!/bin/bash
#SBATCH --mem=64G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=10:00:00  
#SBATCH --account=st-gpleiss-1
#SBATCH --mail-user=txu25@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=mpd_on_ackley
#SBATCH --output=slurm/%j.out      # Specify the output file

source ~/.bashrc

module load miniconda3

# Running the file
# cd $PROJECT_DIR
conda activate mujoco

cd local-bo-mpd

echo "Running the file now."
export PYTHONUNBUFFERED=TRUE

python run_custom_experiment.py -c ./configs/turbo_experiment/09212024/mpd_default.yaml -o ackley

echo "Success"

conda deactivate