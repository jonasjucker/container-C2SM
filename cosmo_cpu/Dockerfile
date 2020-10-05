# 
# HPC COSMO image

FROM juckerj/external_swstack:latest
ARG nproc=2

# libgrib1
COPY libgrib1/libgrib1_cosmo/ /usr/local/libgrib1
RUN cd /usr/local/libgrib1/source && \
    make clean -f Makefile.kesch.pgi -j3 && \
    make -f Makefile.kesch.pgi -j3 && \
    cp /usr/local/libgrib1/source/lib* /usr/local/libgrib1/.

# libgrib-api 
COPY libgrib-api /var/tmp/libgrib-api
RUN cd /var/tmp/libgrib-api && \
    ./configure --build=x86_64 --host=x86_64 --prefix=/usr/local/libgrib_api/v1.20.0.2/pgi  --enable-static enable_shared=no --disable-jpeg && \
    make install -j$(nproc) && \
    echo 'export GRIB_DEFINITION_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/definitions/:/usr/local/libgrib_api/v1.20.0.2/pgi/share/grib_api/definitions/\n \
      export GRIB_SAMPLES_PATH=/usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions/samples/\n' \
    >> /usr/local/libgrib_api/v1.20.0.2/pgi/configuration.sh

COPY ./cosmo_definitions/ /usr/local/libgrib_api/v1.20.0.2/pgi/cosmo_definitions

# libjasper 
COPY libjasper /var/tmp/libjasper
RUN cd /var/tmp/libjasper && \
    export libjasper_install=/usr/local/libjasper/ && \
    ./install.sh

# COSMO-ORG without dycore 
COPY ./cosmo /usr/local/cosmo
RUN cd /usr/local/cosmo/cosmo/ACC && cp Options.docker.pgi.cpu Options && \
    export INSTALL_DIR=/usr/local/ && make -j 4

ENV COSMO_HOME=/usr/local/cosmo
ENV PATH=$PATH:/usr/local/cosmo/cosmo/ACC

# prepare workdir with cosmo1_lpi/test_1
RUN mkdir -p /data
RUN cd $COSMO_HOME/cosmo/test/testsuite/data && ./get_data.sh && cp -r cosmo1_lpi/test_1/* /data/.
RUN ln -s /usr/local/cosmo/cosmo/test/testsuite/data/cosmo1_lpi/input /data/.
RUN cd /data && rm YU* && mkdir -p output

WORKDIR /data


