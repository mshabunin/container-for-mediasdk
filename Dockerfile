FROM ubuntu:18.04
ARG HTTP
ARG HTTPS
ENV http_proxy=http://${HTTP}
ENV https_proxy=https://${HTTPS}

RUN apt update && \
    apt install -y \
        git \
        autoconf \
        automake \
        libtool-bin \
        pkg-config \
        g++ \
        gcc \
        cmake \
        make \
        libpciaccess-dev \
        libdrm-dev \
        libxext-dev \
        libxfixes-dev \
        libx11-dev \
        wget \
        ninja-build

RUN mkdir -p /build
WORKDIR /build

# Build libva and other libraries
ENV http_proxy=${HTTP}
ENV https_proxy=${HTTPS}

RUN \
    git clone https://github.com/01org/libva && \
    cd libva && \
    ./autogen.sh && \
    ./configure --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib && \
    make -j8 install

# Build vainfo and test_va_api tools

RUN \
    git clone https://github.com/01org/libva-utils && \
    cd libva-utils && \
    ./autogen.sh && \
    ./configure --enable-tests --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib && \
    make -j8 install

# Build either intel-vaapi-driver ...

# RUN \
#     git clone https://github.com/01org/intel-vaapi-driver && \
#     cd intel-vaapi-driver && \
#     ./autogen.sh && \
#     ./configure --enable-tests --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib && \
#     make -j8 install

# ... or media_driver

RUN \
    git clone https://github.com/intel/media-driver && \
    git clone https://github.com/intel/gmmlib && \
    mkdir build-media-driver && \
    cd build-media-driver && \
    cmake ../media-driver \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DLIBVA_DRIVERS_PATH=/usr/lib/dri \
        -DMEDIA_VERSION="2.0.0" \
        -DBUILD_ALONG_WITH_CMRTLIB=1 \
        -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
        -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
        -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
        -DBS_DIR_MEDIA=`pwd`/../media-driver && \
    make -j8 install
ENV LIBVA_DRIVER_NAME iHD
ENV LIBVA_DRIVERS_PATH /usr/lib/dri

# Build MediaSDK

RUN \
    git clone https://github.com/Intel-Media-SDK/MediaSDK && \
    cd MediaSDK && \
    export MFX_HOME=`pwd` && \
    perl tools/builder/build_mfx.pl --cmake=intel64.make.release --no-warn-as-error && \
    make -j8 -C __cmake/intel64.make.release install
ENV MFX_HOME /opt/intel/mediasdk

VOLUME /work
VOLUME /scripts

CMD /bin/bash
