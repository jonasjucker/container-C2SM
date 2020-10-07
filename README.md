# container-C2SM

## How to run on Piz Daint

### cosmo_cpu (OpenMPI)
* srun -N8 -C gpu -p debug --mpi=pmi2 sarus run juckerj/cosmo:org
### cosmo_cpu_mpich (MPICH)
* srun -n 8 -N1 -C gpu -p debug --mpi=pmi2 sarus run  juckerj/cosmo:mpich cosmo
