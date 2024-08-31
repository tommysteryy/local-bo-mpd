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

module load miniconda3

# Running the file
# cd $PROJECT_DIR
conda activate mpd

cd local-bo-mpd

echo "Running the file now."

python generate_data_synthetic_functions.py -c ./configs/synthetic_experiment/generate_data_default.yaml
python run_synthetic_experiment.py -c ./configs/synthetic_experiment/mpd_default.yaml -cd ./configs/synthetic_experiment/generate_data_default.yaml

echo "Success"

conda deactivate