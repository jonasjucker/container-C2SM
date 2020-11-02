# Test Container
The results of COSMO are tested with the regular testsuite. Besides the container image, the [fork](https://github.com/jonasjucker/cosmo/tree/docker)
of Jonas Jucker is needed as repository to run the testsuite in. One needs the modified mpicmd in the testsuite as well as the testlist *testlist_gpu_noasyncio.xml*.

For the CPU version of the container the original testuite can be uses as well.

## COSMO (CPU)
Run the following commands in the directory *cosmo/test/testsuite*:
```bash
 touch cosmo_cpu && \
 ./src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_mch.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu'
```

```bash
/src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_dwd.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu'
  ```
  **failing tests**
* *cosmo7/test_2* 
   - MPI hangs when using --mpi option with Sarus, passing --mpi=pmi2 to srun instead resolves it.

## COSMO (GPU)
Run the following commands in the directory *cosmo/test/testsuite*:
```bash
export MALLOC_MMAP_MAX_=0
export MALLOC_TRIM_THRESHOLD_=536870912
export MPICH_G2G_PIPELINE=256
ulimit -s unlimited
ulimit -a

 touch cosmo_gpu && \
 ./src/testsuite.py -n 2 -v 1 --nprocio=0 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_gpu_noasyncio.xml -o testsuite.out \
 --mpicmd='srun -u --ntasks-per-node=1 -n &NTASKS -C gpu -t5 -p debug sarus run --mpi \
 --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
 --workdir=$PWD juckerj/cosmo:gpu'

```
** failing tests**
* a lot still ongoing conversation with Theo from CSCS
