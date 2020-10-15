# container-C2SM

## How to run on Piz Daint
### cosmo_cpu (juckerj/cosmo:cpu on Dockerhub)
#### Testsuite
```bash
 touch cosmo_cpu && \
 ./src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_mch.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu cosmo'
```
```bash
/src/testsuite.py -n 12 -v 1 --color -f --tolerance=TOLERANCE_dp \
 --testlist=testlist_dwd.xml -o testsuite.out --mpicmd=' srun -u \
 --ntasks-per-node=12 -C gpu -p debug \
  sarus run --mpi --mount=type=bind,src=$PWD/../../../,target=$PWD/../../../ \
  --workdir=$PWD juckerj/cosmo:cpu cosmo'
  ```
