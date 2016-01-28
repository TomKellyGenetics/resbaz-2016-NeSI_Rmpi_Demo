#!/bin/bash
#SBATCH -A uoo00010
#SBATCH -J nesi_demo_test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kelsi602@student.otago.ac.nz
#SBATCH --ntasks 100
#SBATCH --cpus-per-task=1
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=1G
module load R/3.1.1-goolf-1.5.14
srun Rscript NeSI_Demo_parallel_test.R
