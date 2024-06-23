#!/bin/bash
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
#SBATCH --time=0:30:00  
#SBATCH --account=st-gpleiss-1-gpu
#SBATCH --mail-user=txu25@student.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=rl_experiment
#SBATCH -o slurm/output/%j.out    # Specify the error file. The %j will be replaced by the Slurm job id.
#SBATCH -e slurm/errors/%j.err      # Specify the output file

nvidia-smi

source ~/.bashrc

# Running the file
cd $PROJECT_DIR
conda activate mpd
cd local-bo-mpd/
echo "Running the file now."
python run_rl_experiment.py -c ./configs/rl_experiment/mpd_default.yaml
echo "Script was successfully run."
conda deactivate

echo "Beginning transfer of slurm output files."

cd $SCRATCH_DIR/slurm

# if $SLURM_JOB_ID.out exists, copy it to $PROJECT_DIR/slurm/output
if [ -f output/$SLURM_JOB_ID.out ]; then
    echo "Found output file."
    cp "output/$SLURM_JOB_ID.out" "/home/txu25"
fi

# if $SLURM_JOB_ID.err exists, copy it to $PROJECT_DIR/slurm/errors
if [ -f errors/$SLURM_JOB_ID.err ]; then
    echo "Found error file."
    cp "errors/$SLURM_JOB_ID.err" "$PROJECT_DIR/slurm/errors"
fi

# TODO: Copy over GPU stats file too
