#!/bin/bash

echo "Start cloning repos..."
workdir=$(pwd)

git clone git@github.com:C2SM-RCM/libgrib1.git

git clone git@github.com:C2SM-RCM/libjasper.git

git clone --branch docker git@github.com:jonasjucker/cosmo.git

wget https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.14.1-Source.tar.gz
tar xpzf eccodes-2.14.1-Source.tar.gz && rm eccodes-2.14.1-Source.tar.gz

git clone git@github.com:COSMO-ORG/eccodes-cosmo-resources.git
cd eccodes-cosmo-resources
git checkout 15f3a862d0349f4fc332e383c69acbed71b7804d
cd ..

echo "***All repos cloned***"

