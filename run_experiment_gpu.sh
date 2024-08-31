#!/bin/bash
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
#SBATCH --time=0:45:00  
#SBATCH --account=st-gpleiss-1-gpu
#SBATCH --mail-user=txu25@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=synthetic_experiment
#SBATCH --output=slurm/%j.out    # Specify the error file. The %j will be replaced by the Slurm job id.

nvidia-smi

source ~/.bashrc

module load miniconda3

# Running the file
# cd $PROJECT_DIR
conda activate mpd

cd local-bo-mpd

echo "Running the file now."

python generate_data_synthetic_functions.py -c ./configs/synthetic_experiment/generate_data_default.yaml
python run_synthetic_experiment.py -c ./configs/synthetic_experiment/mpd_default.yaml -cd ./configs/synthetic_experiment/generate_data_default.yaml

echo "Script was successfully run."
conda deactivate
