# 
# external software stack for HPC COSMO image
# 
# Contents:
#   CUDA version 11.0
#   HDF5 version 1.10.1
#   Mellanox OFED version 5.0-2.1.8.0 
#   OpenMPI version 3.0.0
#   PGI compilers version 20.7
#   Python 2 and 3 (upstream)
# 

FROM nvidia/cuda:11.0-devel-ubuntu20.04 AS devel
ARG nproc=8

# Python
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python \
        python3 vim && \
    rm -rf /var/lib/apt/lists/*

# PGI compiler version 20.7
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        libnuma1 \
        perl \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/tmp/nvhpc && \
             wget https://developer.download.nvidia.com/hpc-sdk/nvhpc_2020_207_Linux_x86_64_cuda_11.0.tar.gz -P /var/tmp/nvhpc/ && \
             tar xpzf /var/tmp/nvhpc/nvhpc_2020_207_Linux_x86_64_cuda_11.0.tar.gz -C /var/tmp/nvhpc -z && \
             cd /var/tmp/nvhpc/nvhpc_2020_207_Linux_x86_64_cuda_11.0 && \
             PGI_INSTALL_MPI=false \
             NVHPC_SILENT=true \
             NVHPC_INSTALL_DIR=/opt/nvidia \
             ./install && \
             echo "variable LIBRARY_PATH is environment(LIBRARY_PATH);" >> /opt/nvidia/Linux_x86_64/20.7/compilers/bin/siterc && \
             echo "variable library_path is default(\$if(\$LIBRARY_PATH,\$foreach(ll,\$replace(\$LIBRARY_PATH,":",), -L\$ll)));" >> /opt/nvidia/Linux_x86_64/20.7/compilers/bin/siterc && \
             echo "append LDLIBARGS=\$library_path;" >> /opt/nvidia/Linux_x86_64/20.7/compilers/bin/siterc && \
             rm -rf /var/tmp/nvhpc 

ENV LD_LIBRARY_PATH=/opt/nvidia/Linux_x86_64/20.7/compilers/lib:$LD_LIBRARY_PATH \
    PATH=/opt/nvidia/Linux_x86_64/20.7/compilers/bin:$PATH

# Mellanox OFED version 5.0-2.1.8.0 
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libnl-3-200 \
        libnl-route-3-200 \
        libnuma1 \
        wget && \
        rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/tmp && \ 
    wget -q -nc --no-check-certificate \
    -P /var/tmp \
    http://content.mellanox.com/ofed/MLNX_OFED-5.0-2.1.8.0/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64.tgz && \
    mkdir -p /var/tmp && \
    tar -x -f /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64.tgz \
    -C /var/tmp -z && \
    dpkg --install /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibverbs1_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibverbs-dev_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/ibverbs-utils_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibmad_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibmad-devel_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibumad_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libibumad-devel_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libmlx4-1_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libmlx4-dev_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libmlx5-1_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/libmlx5-dev_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/librdmacm-dev_*_amd64.deb \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64/DEBS/MLNX_LIBS/librdmacm1_*_amd64.deb && \
    rm -rf /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64.tgz \
    /var/tmp/MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu20.04-x86_64

## OpenMPI version 3.0.0 PMI-enabled for Sarus on Piz Daint
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bzip2 \
        build-essential \
        ca-certificates \
        automake \
        autoconf \
        libpmi2-0-dev \
        file \
        hwloc \
        libnuma-dev \
        make \
        openssh-client \
        perl \
        tar \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
    && tar xf mpich-3.1.4.tar.gz \
    && cd mpich-3.1.4 \
    && ./configure --enable-fast=all,O3 --prefix=/usr/local/mpich \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mpich-3.1.4 \
    && rm mpich-3.1.4.tar.gz
ENV LD_LIBRARY_PATH=/usr/local/mpich/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/mpich/bin/:$PATH

## CMake version 3.14.5
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.sh && \
    /bin/sh /var/tmp/cmake-3.14.5-Linux-x86_64.sh --prefix=/usr/local --skip-license && \
    rm -rf /var/tmp/cmake-3.14.5-Linux-x86_64.sh

# HDF5 version 1.10.1
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bzip2 \
        file \
        make \
        wget \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.bz2 && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/hdf5-1.10.1.tar.bz2 -C /var/tmp -j && \
    cd /var/tmp/hdf5-1.10.1 &&  CC=pgcc CXX=pgc++ F77=pgfortran F90=pgfortran FC=pgfortran ./configure --prefix=/usr/local/hdf5 --enable-cxx --enable-fortran && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/hdf5-1.10.1.tar.bz2 /var/tmp/hdf5-1.10.1
ENV HDF5_DIR=/usr/local/hdf5 \
    LD_LIBRARY_PATH=/usr/local/hdf5/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/hdf5/bin:$PATH

# NetCDF version 4.6.1, NetCDF C++ version 4.3.0, NetCDF Fortran
# version 4.4.4
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        file \
        libcurl4-openssl-dev \
        m4 \
        make \
        wget \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-4.6.1.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/netcdf-4.6.1.tar.gz -C /var/tmp -z && \
    cd /var/tmp/netcdf-4.6.1 &&  CC=pgcc CPPFLAGS=-I/usr/local/hdf5/include CXX=pgc++ F77=pgfortran F90=pgfortran FC=pgfortran LDFLAGS=-L/usr/local/hdf5/lib ./configure --prefix=/usr/local/netcdf && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/netcdf-4.6.1.tar.gz /var/tmp/netcdf-4.6.1 && \
    mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-cxx4-4.3.0.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/netcdf-cxx4-4.3.0.tar.gz -C /var/tmp -z && \
    cd /var/tmp/netcdf-cxx4-4.3.0 &&  CC=pgcc CPPFLAGS=-I/usr/local/netcdf/include CXX=pgc++ F77=pgfortran F90=pgfortran FC=pgfortran LD_LIBRARY_PATH='/usr/local/netcdf/lib:$LD_LIBRARY_PATH' LDFLAGS=-L/usr/local/netcdf/lib ./configure --prefix=/usr/local/netcdf && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/netcdf-cxx4-4.3.0.tar.gz /var/tmp/netcdf-cxx4-4.3.0 && \
    mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.4.4.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/netcdf-fortran-4.4.4.tar.gz -C /var/tmp -z && \
    cd /var/tmp/netcdf-fortran-4.4.4 &&  CC=pgcc CPPFLAGS=-I/usr/local/netcdf/include CXX=pgc++ F77=pgfortran F90=pgfortran FC=pgfortran LD_LIBRARY_PATH='/usr/local/netcdf/lib:$LD_LIBRARY_PATH' LDFLAGS=-L/usr/local/netcdf/lib ./configure --prefix=/usr/local/netcdf && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/netcdf-fortran-4.4.4.tar.gz /var/tmp/netcdf-fortran-4.4.4
ENV LD_LIBRARY_PATH=/usr/local/netcdf/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/netcdf/bin:$PATH

# perl 5.16.3 (needed by automake 1.13)
RUN cd /var/tmp && \
    wget https://www.cpan.org/src/5.0/perl-5.16.3.tar.gz && \
    tar xvf perl-5.16.3.tar.gz && \
    cd perl-5.16.3 && \
    sh Configure  -de && \
    make -j$(nproc) && \
    make install

ENV PATH=/usr/local/bin/:$PATH

# automake 1.13
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf

RUN cd /var/tmp && \
    wget http://ftp.gnu.org/gnu/automake/automake-1.13.tar.gz && \
    tar xvf automake-1.13.tar.gz && \
    cd automake-1.13 && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    rm -rf /var/tmp/automake-1.13.tar.gz
