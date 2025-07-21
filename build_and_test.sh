#!/usr/bin/env bash

set -euo pipefail

export LD_LIBRARY_PATH=/opt/libfabric-install/lib:/opt/mercury-install/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/opt/libfabric-install/lib/pkgconfig:/opt/mercury-install/lib/pkgconfig:$PKG_CONFIG_PATH
export MERCURY_INSTALL_DIR=/opt/mercury-install


options=(
  PDC_ENABLE_PROFILING
  PDC_TIMING
  PDC_SERVER_CACHE
  PDC_ENABLE_MULTITHREAD
)

SRC_DIR=/opt/pdc
BUILD_DIR=$SRC_DIR/build

stat $SRC_DIR

for opt in "${options[@]}"; do
  for val in ON OFF; do
    echo "Building with $opt=$val"

    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"

    cmake -DPDC_ENABLE_MPI=ON -DBUILD_MPI_TESTING=ON -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON \
	  -DMERCURY_DIR=/opt/mercury-install \
	  -DMERCURY_INCLUDE_DIR=/opt/mercury-install/include \
	  -DMERCURY_LIBRARY=/opt/mercury-install/lib/libmercury.so \
	  -DMERCURY_NA_LIBRARY=/opt/mercury-install/lib/libna.so \
	  -DMERCURY_UTIL_LIBRARY=/opt/mercury-install/lib/libmercury_util.so \
	  -DCMAKE_C_COMPILER=mpicc \
	  -DMPI_RUN_CMD=mpiexec \
	  -D${opt}=$val \
	  ..

    make -j$(nproc)
    ctest --output-on-failure --timeout 60
  done
done

