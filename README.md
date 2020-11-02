# Container for COSMO-ORG 
This report summarizes the experiences and difficulties to build and run a container for COSMO-ORG on both, CPU and GPU.
The target machine for that container is Piz Daint at CSCS.

## General
The main idea to put an application into a container is to be indepenent from system the application runs on.
So far this was only suited for non-compute intensive applications. The performance on HPC-systems was not good compared to applications running on the native system,
because critical libraries as MPI are usually tailored to a specific HPC-machine. The application inside the container uses by definition a general MPI-library, so performance is not optimal
on HPC-systems.

To tackle that deficiency, CSCS developed Sarus, a tool to run containers efficiently on HPC-systems. The main idea of Sarus is to replace performance critical
libraries as MPI during runtime with native implementations from the system. The same kind of replacement, but for GPU-related libraries is necessary to run applications
on multiple GPU's.
Because Piz Daint is the main target machine for the containers described in this document, they contain some tweaks or twist needed for Sarus. On another HPC-system some additional components may be required inside the container.

## How to run on Piz Daint
### cosmo_cpu (juckerj/cosmo:cpu on Dockerhub)
#### Testsuite
Run the following commands in the directory *cosmo/test/testsuite*:
```bash
 touch cosmo_cpu && \
 ./src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_mch.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu cosmo'
```
Failing tests for testlist_mch.xml:
* *cosmo7/test_2* Reason: MPI hangs when using --mpi option with Sarus, passing --mpi=pmi2 to srun instead resolves it.
```bash
/src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_dwd.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu cosmo'
  ```
  Failing tests for testlist_dwd.xml:
  * *None*
#### Simulations
Run the following command in a sandbox containing all INPUT namelists and all input data.
The results of the simulation will be written at this location too.
```bash
srun -n $NUMBER_OF_PROC -C gpu sarus run --mpi \
--mount=type=bind,src=$PWD,target=$PWD --workdir=$PWD \
juckerj/cosmo:cpu cosmo
```
