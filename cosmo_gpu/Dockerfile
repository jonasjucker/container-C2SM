# 
# HPC COSMO image

FROM juckerj/external_swstack:mpich
ARG nproc=2

# libgrib1
COPY libgrib1/libgrib1_cosmo/ /usr/local/libgrib1
RUN cd /usr/local/libgrib1/source && \
    make clean -f Makefile.kesch.pgi -j3 && \
    make -f Makefile.kesch.pgi -j3 && \
    cp /usr/local/libgrib1/source/lib* /usr/local/libgrib1/.

# ECCODES 2.14
COPY eccodes-2.14.1-Source /var/tmp/eccodes
RUN cd /var/tmp/ && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/eccodes \
    -DENABLE_JPG_LIBJASPER=ON -DCMAKE_Fortran_COMPILER=pgfortran ../eccodes && \
    make -j $(nproc) && \
    ctest && \
    make install 

# eccodes-cosmo-resources
COPY ./eccodes-cosmo-resources /usr/local/eccodes/eccodes-cosmo-resources
ENV GRIB_DEFINITION_PATH=/usr/local/eccodes/eccodes-cosmo-resources/definitions:/usr/local/eccodes/share/eccodes/definitions/
ENV GRIB_SAMPLES_PATH=/usr/local/eccodes/eccodes-cosmo-resources/samples/

# libjasper 
COPY libjasper /var/tmp/libjasper
RUN cd /var/tmp/libjasper && \
    export libjasper_install=/usr/local/libjasper/ && \
    ./install.sh

# Gritool Dycore 2.0
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        libboost-all-dev \
        gfortran \
        git && \
    rm -rf /var/lib/apt/lists/*

COPY gridtools /var/tmp/gridtools
ENV CXX=/usr/bin/g++ CC=/usr/bin/gcc FC=/usr/bin/gfortran CUDACXX=/opt/nvidia/Linux_x86_64/20.7/compilers/bin/nvcc CUDAHOSTCXX=/usr/bin/g++
RUN cd /var/tmp/gridtools && \
    mkdir build && cd build && \
    cmake -DCUDAToolkit_INCLUDE_DIR=/usr/local/cuda-11.0/include/ \
    -DCUDA_CUDART=/usr/local/cuda/lib64/ \
    -DCMAKE_INSTALL_PREFIX=/usr/local/gridtools \
    ../.  && \
    make && \
    make install

# Serialbox
COPY serialbox /var/tmp/serialbox
RUN cd /var/tmp/serialbox && mkdir build && cd build && \
    cmake ../. \
    -DCMAKE_INSTALL_PREFIX=/usr/local/serialbox \
    -DSERIALBOX_ENABLE_FORTRAN=true && \
    make install

# COSMO-ORG 
COPY ./cosmo /usr/local/cosmo
#RUN cd /usr/local/cosmo/dycore && mkdir dycore_build && cd dycore_build && \
#    cmake ../. -DCMAKE_BUILD_TYPE=Release \
#    -DGridTools_DIR=/usr/local/gridtools/lib/cmake/GridTools/ \
#    -DDYCORE_TARGET_ARCHITECTURE=gpu \
#    -DCMAKE_INSTALL_PREFIX=/usr/local/cosmo/dycore/install_release \
#    -DCUDA_CUDART=/usr/local/cuda/lib64 \
#    -DCUDAToolkit_INCLUDE_DIR=/usr/local/cuda-11.0/include/ \
#    -DCUDA_ARCH=sm_60 \
#    -DSerialbox_DIR=/usr/local/serialbox/cmake/ \
#    -DGT_ENABLE_BINDINGS_GENERATION=ON \
#    -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON 

#DYCORE

#RUN cd /usr/local/cosmo/cosmo/ACC && cp Options.docker.pgi.gpu Options && \
#    export INSTALL_DIR=/usr/local/ && make -j 4
#
#ENV COSMO_HOME=/usr/local/cosmo
#ENV PATH=$PATH:/usr/local/cosmo/cosmo/ACC
#
## prepare workdir with cosmo-2e,test_1
#RUN mkdir -p /data
#RUN cd $COSMO_HOME/cosmo/test/testsuite/data && ./get_data.sh && cp -r cosmo-2e/test_1/* /data/.
#RUN ln -s /usr/local/cosmo/cosmo/test/testsuite/data/cosmo-2e/input /data/.
#RUN cd /data && rm YU* && mkdir -p output
#ENV GRIB_DEFINITION_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/definitions/:/usr/local/libgrib_api/v1.20.0.2/pgi/share/grib_api/definitions/
#ENV GRIB_SAMPLES_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/samples/
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/compat/
#WORKDIR /data


