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

# libjasper 
COPY libjasper /var/tmp/libjasper
RUN cd /var/tmp/libjasper && \
    export libjasper_install=/usr/local/libjasper/ && \
    ./install.sh

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

# COSMO-ORG without dycore 
COPY ./cosmo /usr/local/cosmo
RUN cd /usr/local/cosmo/cosmo/ACC && cp Options.docker.pgi.cpu Options && \
    export INSTALL_DIR=/usr/local/ && make -j 4 && \
    ldconfig

ENV COSMO_HOME=/usr/local/cosmo
ENV PATH=$PATH:/usr/local/cosmo/cosmo/ACC

## prepare workdir with cosmo-2e,test_1
#RUN mkdir -p /data
#RUN cd $COSMO_HOME/cosmo/test/testsuite/data && ./get_data.sh && cp -r cosmo-2e/test_1/* /data/.
#RUN ln -s /usr/local/cosmo/cosmo/test/testsuite/data/cosmo-2e/input /data/.
#RUN cd /data && rm YU* && mkdir -p output
#ENV GRIB_DEFINITION_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/definitions/:/usr/local/libgrib_api/v1.20.0.2/pgi/share/grib_api/definitions/
#ENV GRIB_SAMPLES_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/samples/
#WORKDIR /data

# prepare workdir with cosmo-2e,test_1
RUN mkdir -p /data
RUN cd $COSMO_HOME/cosmo/test/testsuite/data && ./get_data.sh 
RUN cd /data mkdir -p output
ENV LD_LIBRARY_PATH=/usr/local/eccodes/lib:$LD_LIBRARY_PATH  
ENV PATH=/usr/local/eccodes/bin/:$PATH
WORKDIR /data

