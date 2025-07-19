#!/bin/bash 
#SBATCH -n 1
#SBATCH --gres=gpu:h100_80gb:1
#SBATCH --mem=480G
#SBATCH -N 1

# Use this information for --mpi=pmi2 option below
srun --mpi=list

# This is needed because the maximum locked memory is not set to unlimited.
ulimit -l unlimited

# No scratch here
srun --mpi=pmi2 -n 1 singularity run --nv -B "/project:/project" --env HPL_USE_NVSHMEM=0 hpc-benchmarks-23.10.sif /workspace/hpl.sh --dat HPL.dat --no-multinode
