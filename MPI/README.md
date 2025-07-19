# HPL example with MPI
This example uses MPI. Setup is straight-forward compilation. The HPL.dat file included has not been fine tuned to maximize the performance of any component and is intended as a starting point for using MPI on the BigBlue cluster. Performance figures have not been rigorously obtained.

# Setup
Run the following to get the HPL source code:
```
wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
tar -xzf hpl-2.3.tar.gz
cd hpl-2.3
```

After obtaining the source, you can pick either MKL or OpenBLAS for the linear algebra library. ATLAS or GOTOBLAS would require you to compile those seperately. The normal LAPACK library can work, but it might be slow. Using different version of MPI is possible. We have MPICH, Intel MPI, and OpenMPI for MPI. MVAPICH would require you to compile that seperately.

## MKL and intel MPI
Compile using the following procedure for MKL:
```
module purge
module load intel/mkl/2024.0 intel/compiler/2024.0.2 intel/mpi/2021.11
./configure
make
cp ../HPL.dat testing/
cp ../hpl_mkl.sh testing/hpl.sh
```

If you change something and need to recompile, you can either start over or run `make clean` and `./configure` again.

## OpenBLAS and OpenMPI
Compile using the following procedure for OpenBLAS:
```
module purge
module load openmpi/4.1.6/gcc.8.5.0/mt openblas/0.3.26/gcc-8.5.0/nonthreaded
./configure
make
cp ../HPL.dat testing/
cp ../hpl_openblas.sh testing/hpl.sh
```

If you change something and need to recompile, you can either start over or run `make clean` and `./configure` again.

# Submission
Use sbatch to submit the hpl benchmark:
```
cd testing
sbatch hpl.sh
```

The result will be recorded in a slurm-#####.out file. For any of the Intel nodes, with "i" prefix in the partition name, you can use up to 40 tasks per node, and for the AMD nodes, with "a" prefix in the partition name, you can use up to 192 tasks per node. With MKL, the older Intel nodes get about 1.8 TFlops and the newer AMD nodes get about 5.5 TFlops. With OpenBLAS, it is about 1.7 TFlops and 5.3 TFlops per Intel and AMD node, respectively. There are other versions of OpenBLAS that can be used. Keep in mind that the 0.2 variants of OpenBLAS don't compile with AVX512 support by default, so the performance is much lower. Another note is that using "--ntasks" on other partitions will result in the job running on more than one node, but the performance should be similar since the 100 Gb/s Infiniband network should be fast enough. Using much more than 192 tasks will decrease the performance per task a little due to the communication overhead.

# HPL.dat file
This file defines the parameters for the HPL benchmark. Increasing "Ns" (problem size) increases the memory usage. "Nb" on line 8 is the block size. "Ps" and "Qs" are row and columns of the process grid and these need to multiply out to the number of tasks allocated to the job. So if you allocated 3 tasks, you would need "Ps" to be 3 and "Qs" to be 1. If you allocated 6 tasks, you would need "Ps" to be 3 and "Qs" to be 2, etc...

# Citations and other reading material
[HPL benchmark](https://netlib.org/benchmark/hpl/)
[OpenBLAS](https://github.com/OpenMathLib/OpenBLAS/)
[OpenMPI](https://www.open-mpi.org/)
[Intel MKL library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html)
[Intel MPI library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/mpi-library.html)
[HPL Tuning](https://www.netlib.org/benchmark/hpl/tuning.html)
