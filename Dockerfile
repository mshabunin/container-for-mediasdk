FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    perl \
    g++-5 \
    gcc-5

ARG UNAME=test
ARG UID
ARG GID
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    pkg-config \
    autoconf \
    libtool \
    libdrm-dev \
    xorg \
    xorg-dev \
    openbox \
    libx11-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dev

USER root
RUN mkdir /workspace
WORKDIR /workspace
RUN \
    git clone https://github.com/01org/libva.git && \
    git clone https://github.com/intel/gmmlib && \
    git clone https://github.com/intel/media-driver
RUN \
    cd libva && \
    git checkout df544cd5a31e54d4cbd33a391795a8747ddaf789 && \
    git clean -dfx && \
    ./autogen.sh && \
    make -j8 install
RUN \
    mkdir build-media-driver && cd build-media-driver && \
    cmake ../media-driver \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DMEDIA_VERSION="2.0.0" \
        -DBUILD_ALONG_WITH_CMRTLIB=1 \
        -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
        -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
        -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
        -DBS_DIR_MEDIA=`pwd`/../media-driver && \
    make -j8 install

RUN \
    git clone https://github.com/Intel-Media-SDK/MediaSDK msdk
RUN \
    cd msdk && \
    git checkout master && \
    git clean -dfx && \
    export MFX_HOME=`pwd` && \
    perl tools/builder/build_mfx.pl --cmake=intel64.make.release --no-warn-as-error && \
    make -j8 -C __cmake/intel64.make.release install

RUN apt-get update && apt-get install -y \
    vainfo

RUN usermod -a -G video $UNAME

RUN chmod -R a+rwx /opt/intel

VOLUME /work

USER $UNAME
WORKDIR /work/
CMD ./build.sh
