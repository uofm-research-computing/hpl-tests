#!/bin/bash
#SBATCH --ntasks=192
#SBATCH --mem-per-cpu=3900M
#SBATCH --partition=awholeq
#SBATCH -t 1:00:00

module load openblas/0.3.26/gcc-8.5.0/nonthreaded openmpi/4.1.6/gcc.8.5.0/mt

mpirun ./xhpl
