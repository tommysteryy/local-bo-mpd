#!/bin/bash
#SBATCH --mem=64G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=8:00:00  
#SBATCH --account=st-gpleiss-1
#SBATCH --mail-user=txu25@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=mpd
#SBATCH --output=slurm/%j.out      # Specify the output file

source ~/.bashrc

module load miniconda3

# Running the file
# cd $PROJECT_DIR
conda activate mpd

cd local-bo-mpd

echo "Running the file now."

# python generate_data_synthetic_functions.py -c ./configs/synthetic_experiment/generate_data_default.yaml
# python run_synthetic_experiment.py -c ./configs/synthetic_experiment/mpd_default.yaml -cd ./configs/synthetic_experiment/generate_data_default.yaml

python run_rl_experiment.py -c ./configs/rl_experiment/mpd_default.yaml

echo "Success"

conda deactivate