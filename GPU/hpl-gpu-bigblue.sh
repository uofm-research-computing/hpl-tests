#!/bin/bash 
#SBATCH --ntasks-per-node=1
#SBATCH -p agpuq
#SBATCH --gres=gpu:1
#SBATCH --mem-per-gpu=80G
#SBATCH -N 1

# Prior to submitting this script please run the following commands:
# module load singularity
# singularity pull hpc-benchmarks-23.10.sif docker://nvcr.io/nvidia/hpc-benchmarks:23.10

# This script can execute on one node with up to 2 GPUs.
# Allocate a task, "--ntasks-per-node=1", per GPU, "--gres=gpu:1"
# Allocate 2 tasks, "--ntasks-per-node=2", per 2 GPUs, "--gres=gpu:2"

# Although untested, this script can likely be executed across multiple nodes with
# "--ntasks-per-node=S" and "--gres=gpu:S" where S can be 1 or 2,
# and "-N" up to the total number of nodes in the partition, 4 for "agpuq".

# Use singularity container
module load singularity

# Use this information for --mpi=pmi2 option below
srun --mpi=list

# Make the max "locked" memory unlimited, note that we only have 80 GB 
ulimit -l unlimited

# Breakdown:
#   srun: the SLURM command to start tasks
#   --mpi=pmi2: the default version of the process management interface for our version of SLURM
#   singularity run: the singularity command to run a script/command within a singularity image, in this case "bash" 
#   --nv: pass the visible GPUs inside the container
#   -B: bind a directory, note that we need scratch and project on the cluster, home is mounted by default
#   --env HPL_USE_NVSHMEM=0: do not use NVSHMEM, 0 for no and 1 for yes. It can be 1
#   hpc-benchmarks-23.10.sif: the singularity image we are using
#   /workspace/hpl.sh: an argument passed to bash to execute hpl.sh script from within the image
#   --dat HPL.dat: use this data file for hpl parameters
#   --no-multinode: do not use multiple nodes, remove if "-N" above is more than 1
srun --mpi=pmi2 singularity run --nv -B "/scratch:/scratch" -B "/project:/project" --env HPL_USE_NVSHMEM=0 hpc-benchmarks-23.10.sif /workspace/hpl.sh --dat HPL.dat --no-multinode
