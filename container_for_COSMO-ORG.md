# Container for COSMO-ORG 
This report summarizes the experiences and difficulties to build a container for COSMO-ORG on both, CPU and GPU.
The target machine for that container is Piz Daint at CSCS.

## General
The main idea to put an application into a container is to be indepenent from system the application runs on.
So far this was only suited for non-compute intensive applications. The performance on HPC-systems was not good compared to applications running on the native system,
because critical libraries as MPI are usually tailored to a specific HPC-machine. The application inside the container uses by definition a general MPI-library, so performance is not optimal
on HPC-systems.

To tackle that deficiency, CSCS developed Sarus, a tool to run containers efficiently on HPC-systems. The main idea of Sarus is to replace performance critical
libraries as MPI during runtime with native implementations from the system. The same kind of replacement, but for GPU-related libraries is necessary to run applications
on multiple GPU's.
