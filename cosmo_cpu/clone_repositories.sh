#!/bin/bash

echo "Start cloning repos..."
workdir=$(pwd)

git clone git@github.com:C2SM-RCM/libgrib1.git

git clone --branch libgrib_api_1.20.0.2 git@github.com:C2SM-RCM/libgrib-api-vendor.git libgrib-api

git clone --branch v1.20.0.3 git@github.com:C2SM-RCM/libgrib-api-cosmo-resources.git cosmo_definitions

git clone git@github.com:C2SM-RCM/libjasper.git

git clone --branch docker git@github.com:jonasjucker/cosmo.git

echo "***All repos cloned***"

