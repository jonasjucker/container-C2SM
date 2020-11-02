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
Because Piz Daint is the main target machine for the containers described in this document, they contain some tweaks or twist needed for Sarus. On another HPC-system some additional components may be required inside the container.

## Images
The images/containers for COSMO-ORG are built in two steps, adding three images on top of each other.

### Base Image
As a base image we use an official CUDA image from NVIDIA.
On Piz Daint the newest version supported is 10.2.
Therefore we use **nvidia/cuda:10.2-devel-ubuntu18.04**

### External Software Stack
On top of the CUDA image we install a whole bunch of libraries from source in order to compile COSMO-ORG on both CPU and GPU.  
   * PGI 20.7 
   * MPICH 3.1.4  
   * HDF5 1.10.1  
   * NetCDF 4.6.1
   * NetCDF C++ 4.3.0
   * NetCDF Fortran 4.4.4  
   * Perl 5.16.3  
   * Automake 1.13
   
#### PGI 20.7 
PGI 20.7 is installed with the HPC-development-toolkit from NVIDIA. We do so, because this is the only option the get a free version
of the PGI. By passing *NVHPC_DEFAULT_CUDA=10.2* to the install-script, we ensure that the same CUDA-version from the base image is installed. So the container then has two seperate CUDA instances installed, which one is used to compile COSMO-ORG in the end is not clear. The community version of PGI is valid for around a year, the package needs to be dowloaded from the NVIDIA webpage. A change in the distribution-policy of NVIDIA could well make this key-component of the images **unavailable**.

#### MPICH 3.1.4
The default MPI-library of COSMO-ORG is OpenMPI. Sarus does not support the native-MPI hook with OpenMPI, therefore we use MPICH.
More detailed descriptions about the MPI-hook of Sarus can be found in the [official documentation](https://sarus.readthedocs.io/en/stable/config/mpi-hook.html).

## External Software Stack


