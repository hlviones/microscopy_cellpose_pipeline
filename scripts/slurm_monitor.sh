#!/bin/bash

# Parse command-line arguments
clean=false
core_count=2

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean) clean=true;;
        --core-count) core_count="$2"; shift;;
        *) echo "Unknown parameter passed: $1"; exit 1;;
    esac
    shift
done


# Set the base directory as the current working directory
base_dir=$(pwd)
echo $base_dir

# Create the log directory
mkdir -p "$base_dir/log/${SLURM_JOB_ID}/${core_count}_core/monitor"
mkdir -p "$base_dir/log/${SLURM_JOB_ID}/${core_count}_core/node"
output_file="$base_dir/log/${SLURM_JOB_ID}/${1}_core/monitor/"

#SBATCH --job-name=CELLPOSE_MONITOR_JOB
#SBATCH --output=slurm_monitor.log

echo "Checking for missing dependancies"

# Check if the Fiji executable exists
fiji_executable="./Fiji.app/ImageJ-linux64"
if [ ! -x "$fiji_executable" ]; then
    echo "Error: Fiji executable not found. Please ensure that the Fiji folder is located at: ./Fiji.app/ and contains the ImageJ-linux64 executable."
    exit 1
fi
echo "Fiji folder found"

# Check if files exist in the input folder
input_folder="$base_dir/input"
if [ -z "$(ls -A "$input_folder")" ]; then
    echo "Error: No files found in the input folder: $input_folder"
    exit 1
fi
echo "Files found in input folder"


echo "Starting fiji processing"
start_time=$(date +%s)  # Record the start time

# Run your Fiji script and capture the console output
output=$(./Fiji.app/ImageJ-linux64 --headless --console -macro "$base_dir/fiji.ijm")

# Initialize line count
num_lines=0

# Iterate over each line of the console output
while IFS= read -r line; do
  # Check if the line contains a .tif file path
  if [[ $line == *".tif" ]]; then
    filename=$(basename "$line")
    echo "Processing $filename"

    # Create the directory based on the file path
    mkdir -p "${line%.tif}"
    # Move the file to the created directory
    mv "$line" "${line%.tif}"

    # Increment the line count
    ((num_lines++))
  fi
done <<< "$output"

echo "Total lines with .tif: $num_lines"

echo "Number of cores to allocate: $core_count"

# Pass the line count as a parameter to the subsequent sbatch command
sbatch --array=1-"$num_lines" "$base_dir/cellpose_node_split.sh" "$core_count"

# Run the squeue command and count the number of lines
count_jobs() {
    squeue_output=$(squeue -u hlviones)
    num_lines=$(echo "$squeue_output" | wc -l)
    # Subtract 1 to exclude the header line
    num_jobs=$((num_lines - 1))
    echo "$num_jobs"
}

# Loop until there is only one job left
while true; do
    num_jobs=$(count_jobs)
    if [ "$num_jobs" -eq 1 ]; then
        break
    fi
    sleep 5  # Wait for 5 seconds before checking again
done

end_time=$(date +%s)  # Record the end time
execution_time=$((end_time - start_time))  # Calculate the execution time in seconds
echo "$execution_time" >> execution_times.csv

echo "Script execution time: $execution_time seconds"

# CLEAN

if [ "$clean" = true ]; then
    rm -rf "$base_dir/output/"*
    find "$base_dir" -name "slurm-*_*.out" -exec mv {} "$base_dir/log/${SLURM_JOB_ID}/${1}_core/node" \;
    find "$base_dir" -name "slurm-*" -exec mv {} "$output_file" \;
fi
