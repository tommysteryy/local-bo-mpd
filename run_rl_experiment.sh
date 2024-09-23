#!/bin/bash
#SBATCH --mem=64G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=10:00:00  
#SBATCH --account=st-gpleiss-1
#SBATCH --mail-user=<YOUR-EMAIL>
#SBATCH --mail-type=ALL
#SBATCH --job-name=mpd
#SBATCH --output=slurm/%j.out      # Specify the output file

source ~/.bashrc

module load miniconda3

# Running the file
# cd $PROJECT_DIR
conda activate mujoco

cd local-bo-mpd

echo "Running the file now."
export PYTHONUNBUFFERED=TRUE

python run_rl_experiment.py -c ./configs/rl_experiment/09042024/mpd_w_turbo.yaml
python evaluation_rl_experiment.py -cs ./configs/rl_experiment/09042024/mpd_w_turbo.yaml -path ./plots/09042024/mpd_w_turbo.png

echo "Success"

conda deactivate