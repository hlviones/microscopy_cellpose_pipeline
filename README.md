# Microscopy Cellular Segmentation Pipeline

This project is a collection of scripts for executing a microscopy cellpose pipeline.

## Overview


The microscopy cellpose pipeline consists of a set of scripts that automate the processing of microscopy images using the Cellpose algorithm. The pipeline performs image segmentation and analysis tasks on a collection of input images and generates corresponding output results. The aim of this project was to automate the previously manually run pipeline and to move it from a single windows machine to the [PGB-CBF joint cluster](https://pgb.liv.ac.uk/~hlviones/doc/). This implementation was a major improvement on the previous system and resulted in a 60x reduction in run time.

## Workflow

![Untitled-1](https://github.com/hlviones/microscopy_cellpose_pipeline/assets/83133751/264e1b48-7cd1-4610-b4ab-3853e7c147b2)

## Example Output
![image](https://github.com/hlviones/microscopy_cellpose_pipeline/assets/83133751/77e7edfb-59ca-4c82-a26d-30a3384363b4)
![image](https://github.com/hlviones/microscopy_cellpose_pipeline/assets/83133751/e4e31c02-0c7e-4a12-8d07-8bc49284bb92)



## Folder Structure

- `input`: Contains the input images.
- `output`: Stores the output results.
- `scripts`: Contains the main scripts for running the pipeline.

## Setup Steps

1. Clone this repository
2. Navigate to base directory
3. conda env create -f cellpose.yml

## Usage

1. Place the input images in the `input` folder.
2. Modify the necessary parameters in the scripts to fit your specific requirements.
3. Execute the pipeline by running the scripts in the following order:
    1. Go to the scripts folder
    2. Run the `sbatch slurm_monitor.sh` script to execute the main pipeline.
    3. (Optional) Add the `--clean` argument to clean up intermediate files.
    4. (Optional) Specify the `--core-count` argument to allocate a specific number of CPU cores for parallel processing.

Note: Make sure to adjust the paths in the scripts if necessary to match your specific environment.

## Acknowledgments

Many thanks to the University of Liverpool Computation Biology Facility [CBF](https://www.liverpool.ac.uk/computational-biology-facility/) and Center for Cell Imaging [CCI](https://www.liverpool.ac.uk/health-and-life-sciences/research/liverpool-shared-research-facilities/bio-imaging/centre-for-cell-imaging/) 


## License

This project is licensed under the [MIT License](LICENSE).
