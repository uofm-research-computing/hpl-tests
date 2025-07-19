# University of Memphis HPL examples
This is a starting point for using MPI and GPUs on HPC resources at the University of Memphis. The current cluster, BigBlue, is the primary cluster on campus run by Research Computing. The cluster has almost 10,000 CPU-cores, 20 GPUs, 50 TB of memory, and 700 TB of storage connected together by a 100 Gbit Infiniband network. Most cluster jobs are mixed-use ranging from 1 CPU-core jobs using 1 or 2 GBs of memory to jobs utilizing hundreds of CPU-cores and many TB of memory and even GPUs. Although iTiger isn't the focus of this, the GPU benchmarks were run on a few nodes. These examples utilize the HPL benchmark, but might not be a perfect indicator of performance.

# MPI
These versions utilizes Intel and OpenMPI libraries. They can be used across many nodes up to your CPU-core and memory limits. They can also be used with Intel and AMD nodes. They should not be run on both Intel and AMD nodes in a single job.

# GPU
This version utilizes the Nvidia NGC benchmarks container. Currently, HPL within this container only works with the A100 GPU nodes, but the V100 nodes do work for other tasks and containers.

# Caveats
Taking the performance figures as-is will not give you a good indicator of performance in your application. Running these benchmarks as I've tested achieves a little over 450 TFlops (double-precision, not an all at once cluster measurement, and including both CPUs and GPUs on each node) over the entire cluster. The GPUs alone make about 150 TFlops of that performance number, estimating for some GPUs that don't run the benchmark correctly.

## Precision
The cluster is capable of using many different precisions in your calculations. "Hardware" precisions, like single ("float" in c/c++) and double, will have the highest performance. In most cases, the single-precision calculations are twice as fast as double-precision calculations. All hardware on the cluster can use half-precision, which take up half the space of a single-precision number, and they can perform operations even faster. Arbitrary precision applications will not quite achieve the highest performance, but might be needed for high precision calculations. For the GPUs, this increases the 150 double-precision TFlops estimate to about 300 single-precision TFlops. "Tensor Core" calculations can achieve almost 3840 TFlops of mixed precision (half and single precision) over all GPUs on BigBlue. iTiger can perform almost 108000 TFlops of mixed-precision "Tensor Core" and 6800 TFlops of single-precision operations.

## Communication overhead
Every multiprocessor computation has some overhead from the communication that synchronizes the calculations. In general, more processors will result in more communication overhead. These communication overheads come from transmission latency and speed. Additionally, some calculations in more complex applications might not finish at the same time, resulting in processes waiting for other processes to "catch up".

## Hybrid calculations
Some applications can take advantage of both CPUs and GPUs per calculation, but most do not do that. The scheduler on the cluster can help by allowing CPU and GPU jobs to run concurrently on GPU nodes.

## Neural network operations
Most neural networks use a small subset of operations, primarily matrix multiplication, that are greatly sped up by special purpose hardware. The GPUs on the cluster do have "Tensor Core" units that perform these operations, but they are not tested in these examples.

# Citations and other reading material
[HPL benchmark](https://netlib.org/benchmark/hpl/)

[Tensor Cores](https://developer.nvidia.com/blog/programming-tensor-cores-cuda-9/)

[Double vs Single Precision](https://insidehpc.com/2021/07/double-precision-cpus-vs-single-precision-gpus-hpl-vs-hpl-ai-hpc-benchmarks-traditional-vs-ai-supercomputers/)
