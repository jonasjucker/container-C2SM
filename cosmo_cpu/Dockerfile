# 
# HPC COSMO image
FROM juckerj/external_swstack:cuda10.2
ARG nproc=8

# libgrib1
COPY libgrib1/libgrib1_cosmo/ /usr/local/libgrib1
RUN cd /usr/local/libgrib1/source && \
    make clean -f Makefile.kesch.pgi -j$(nproc) && \
    make -f Makefile.kesch.pgi -j$(nproc) && \
    cp /usr/local/libgrib1/source/lib* /usr/local/libgrib1/.

# libjasper 
COPY libjasper /var/tmp/libjasper
RUN cd /var/tmp/libjasper && \
    export libjasper_install=/usr/local/libjasper/ && \
    ./install.sh && \
    rm -rf /var/tmp/libjasper

# ECCODES 2.14
COPY eccodes-2.14.1-Source /var/tmp/eccodes
RUN cd /var/tmp/ && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/eccodes \
    -DENABLE_JPG_LIBJASPER=ON -DCMAKE_Fortran_COMPILER=pgfortran ../eccodes && \
    make -j $(nproc) && \
    ctest && \
    make install && \
    rm -rf /var/tmp/eccodes
ENV LD_LIBRARY_PATH=/usr/local/eccodes/lib:$LD_LIBRARY_PATH  

# eccodes-cosmo-resources
COPY ./eccodes-cosmo-resources /usr/local/eccodes/eccodes-cosmo-resources
ENV GRIB_DEFINITION_PATH=/usr/local/eccodes/eccodes-cosmo-resources/definitions:/usr/local/eccodes/share/eccodes/definitions/
ENV GRIB_SAMPLES_PATH=/usr/local/eccodes/eccodes-cosmo-resources/samples/
ENV PATH=/usr/local/eccodes/bin/:$PATH

# COSMO-ORG without dycore 
COPY ./cosmo /usr/local/cosmo
RUN cd /usr/local/cosmo/cosmo/ACC && cp Options.docker.pgi.cpu Options && \
    export INSTALL_DIR=/usr/local/ && make -j$(nproc) && \
    ldconfig

ENV COSMO_HOME=/usr/local/cosmo
ENV PATH=$PATH:/usr/local/cosmo/cosmo/ACC

WORKDIR /data

