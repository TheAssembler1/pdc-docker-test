FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libtool \
    autoconf \
    automake \
    pkg-config \
    libnuma-dev \
    libboost-dev \
    curl \
    vim \
    wget \
    uuid-dev \
    mpich && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

RUN git clone https://github.com/ofiwg/libfabric && \
    cd libfabric && \
    git checkout v1.18.0 && \
    ./autogen.sh && \
    CC=mpicc ./configure --prefix=/opt/libfabric-install --enable-sockets=yes --enable-tcp=yes --enable-udp=yes --enable-rxm=yes && \
    make -j$(nproc) && \
    make install && \
    make check

ENV PKG_CONFIG_PATH=/opt/libfabric-install/lib/pkgconfig:$PKG_CONFIG_PATH
ENV LD_LIBRARY_PATH=/opt/libfabric-install/lib:$LD_LIBRARY_PATH

# Build Mercury with libfabric
RUN git clone --recursive https://github.com/mercury-hpc/mercury && \
    cd mercury && \
    git checkout v2.2.0 && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/opt/mercury-install \
      -DCMAKE_C_COMPILER=mpicc \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=ON \
      -DNA_USE_OFI=ON \ 
      -DNA_USE_SM=OFF \
      -DNA_OFI_TESTING_PROTOCOL=sockets \ 
      -DLIBFABRIC_ROOT_DIR=/opt/libfabric-install && \
    make -j$(nproc) && \
    make install && \
    ctest

# Set environment variables
ENV LD_LIBRARY_PATH=/opt/libfabric-install/lib:/opt/mercury-install/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=/opt/libfabric-install/lib/pkgconfig:/opt/mercury-install/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PATH=/opt/libfabric-install/bin:/opt/mercury-install/bin:$PATH
ENV MERCURY_INSTALL_DIR=/opt/mercury-install

