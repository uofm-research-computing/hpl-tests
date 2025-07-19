# HPL benchmark on GPU nodes
This benchmark uses a container provided by Nvidia via their NGC site. There are other benchmarks inside the container including HPCG, but for this example the focus is on HPL benchmark. The HPL.dat file included has not been fine tuned to maximize the performance of any component and is intended as a starting point for using containers, GPUs, and MPI on the BigBlue cluster. Performance figures have not been rigorously obtained.

# Setup
Run the following to pull the container and create the hpc-benchmarks-23.10.sif image
```
module load singularity
singularity pull hpc-benchmarks-23.10.sif docker://nvcr.io/nvidia/hpc-benchmarks:23.10
```

# Submission
Use sbatch to submit the hpl-gpu benchmark:
```
sbatch hpl-gpu-bigblue.sh 
```

The result will be recorded in a slurm-#####.out file. For the "agpuq" partition using A100 GPUs it will be about 8 TFlops on one GPU, very close to the theoretical 9 TFlops maximum. It should work on multiple GPUs and multiple nodes as well. Feel free to modify the script, but keep in mind that it currently only works on the "agpuq" partition using A100 GPUs and not the "igpuq" partition using V100 GPUs. The error reported on the "igpuq" partition is a "segmentation fault", indicating a host memory access issue. The issue might have something to do with host-device memory pinning in combination with the container. Although this particular singularity container doesn't work on the "igpuq" partition, other software and containers work just fine (pytorch, normal CUDA applications, tensorflow, etc...). 

# iTiger
This example works just fine on the iTiger cluster. The "singularity pull" command is the only command needed to obtain the container. No need to run "module load singularity". And you just need to "sbatch" the "hpl-gpu-itiger.sh" script instead. Performance on itiger resulted in 28.5 TFlops per GPU on itiger01, 1.3 TFlops per GPU on itiger03, 0.9 TFlops per GPU on itiger07. Overall, iTiger can perform about 316 double-precision TFlops.

# HPL.dat file
This file defines the parameters for the HPL benchmark. Increasing "Ns" (problem size) increases the memory usage. "Nb" on line 8 is the block size. "Ps" and "Qs" are row and columns of the process grid and these need to multiply out to the number of GPUs and tasks allocated to the job. So if you allocated 3 GPUs and 3 tasks, you would need "Ps" to be 3 and "Qs" to be 1. If you allocated 6 GPUs and tasks, you would need "Ps" to be 3 and "Qs" to be 2, etc... Since iTiger has much more memory per GPU, the "Ns" parameter can be increased significantly. I used 100000 "Ns" on itiger01 node.

# Citations and other reading material
[NGC benchmarks container](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/hpc-benchmarks)

[SLURM MPI user guide](https://slurm.schedmd.com/mpi_guide.html)

[Forum result showing the same V100 error](https://forums.developer.nvidia.com/t/run-hpc-benchmark23-10-hpl-with-v100gpu/273967)

[Wikipedia list of Nvidia GPUs](https://en.wikipedia.org/wiki/List_of_Nvidia_graphics_processing_units#Data_center_GPUs)

[HPL Tuning](https://www.netlib.org/benchmark/hpl/tuning.html)
