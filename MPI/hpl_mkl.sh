#!/bin/bash
#SBATCH --ntasks=192
#SBATCH --mem-per-cpu=3900M
#SBATCH --partition=awholeq
#SBATCH -t 1:00:00

module load intel/mkl/2024.0 intel/compiler/2024.0.2 intel/mpi/2021.11

mpirun ./xhpl
