# base/Dockerfile

FROM ubuntu:22.04

# avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# install basic build tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    mpich \
    libtool \
    pkg-config \
    autoconf \
    automake \
    ca-certificates \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# move to installation directory
ENV WORK_SPACE=/opt/workspace
RUN mkdir -p $WORK_SPACE

# install libfabric
WORKDIR $WORK_SPACE
RUN git clone https://github.com/ofiwg/libfabric
WORKDIR $WORK_SPACE/libfabric
# create installation dir
ENV LIBFABRIC_INSTALL_DIR=$WORK_SPACE/libfabric/install
RUN mkdir -p $LIBFABRIC_INSTALL_DIR
# configure, build, and install
RUN ./autogen.sh
RUN ./configure --prefix=$LIBFABRIC_INSTALL_DIR CC=mpicc CFLAGS="-O2"
RUN make -j$(nproc)
RUN make install
# test
RUN make check

# install mercury
WORKDIR $WORK_SPACE
RUN git clone https://github.com/mercury-hpc/mercury --recursive
WORKDIR $WORK_SPACE/mercury
RUN git checkout v2.2.0
# create installation, build dir
ENV MERCURY_INSTALL_DIR=$WORK_SPACE/mercury/install
RUN mkdir -p $MERCURY_INSTALL_DIR $WORK_SPACE/mercury/build
WORKDIR $WORK_SPACE/mercury/build
# configure, build, and install
RUN cmake -DCMAKE_INSTALL_PREFIX=$MERCURY_INSTALL_DIR -DCMAKE_C_COMPILER=mpicc -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON -DNA_USE_OFI=ON -DNA_USE_SM=OFF -DNA_OFI_TESTING_PROTOCOL=tcp ../
RUN make -j$(nproc)
RUN make install
# test
RUN ctest

# update library and bin paths
ENV LD_LIBRARY_PATH=$LIBFABRIC_INSTALL_DIR/lib:$MERCURY_INSTALL_DIR/lib:$LD_LIBRARY_PATH
ENV PATH=$LIBFABRIC_INSTALL_DIR/bin:$MERCURY_INSTALL_DIR/bin:$PATH

