# container-C2SM

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
