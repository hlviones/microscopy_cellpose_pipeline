#!/bin/bash
cpu="$1"

#SBATCH --job-name=CELLPOSE_SPLIT_ALL
#SBATCH --cpus-per-task="$cpu"

base_dir=$(pwd)
output_file="$base_dir/log/${SLURM_JOB_ID}/${1}_core/node/${SLURM_JOB_ID}"
#SBATCH --output="$output_file"

eval "$(conda shell.bash hook)"
conda activate cellpose_1

echo "Array ID: $SLURM_ARRAY_TASK_ID"
input_dir="$base_dir/output/${SLURM_ARRAY_TASK_ID}_Sancy-tracking_B2_24-stack/${SLURM_ARRAY_TASK_ID}_Sancy-tracking_B2_24-stack.tif"
output_dir="$base_dir/output/${SLURM_ARRAY_TASK_ID}_Sancy-tracking_B2_24-stack"

# Run the cellpose command and capture the execution time in the "time_value" variable
time_value=$({ time python -m cellpose --image_path "$input_dir" --pretrained_model cyto2 --diameter 60 --save_png --flow_threshold 0.4 --save_outlines --fast_mode --save_ncolor --savedir "$output_dir"; } 2>&1)

