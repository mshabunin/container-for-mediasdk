FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        cmake \
        ninja-build \
        g++ \
        git \
        wget \
        curl \
        autoconf \
        automake \
        libtool \
        libxfixes-dev \
        libxext-dev \
        libdrm-dev \
        libpciaccess-dev \
        libudev-dev \
        gdb \
        strace \
        ninja-build \
        python3 \
        virtualenv

ENV LIB_DIR=lib/x86_64-linux-gnu

RUN virtualenv -p python3 /venv && \
    /venv/bin/pip3 install meson

RUN apt-get update && \
    apt-get install -y \
        pkg-config


RUN git clone https://github.com/01org/libva && \
    /venv/bin/meson setup libva build-libva && \
    ninja -C build-libva install

RUN git clone https://github.com/01org/libva-utils && \
    /venv/bin/meson setup libva-utils build-libva-utils && \
    ninja -C build-libva-utils install

RUN git clone https://github.com/intel/media-driver && \
    git clone https://github.com/intel/gmmlib && \
    mkdir -p build-media-driver && cd build-media-driver && \
    cmake -GNinja ../media-driver \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=$LIB_DIR \
        -DLIBVA_DRIVERS_PATH=/usr/$LIB_DIR/dri \
        -DMEDIA_VERSION="2.0.0" \
        -DBUILD_ALONG_WITH_CMRTLIB=1 \
        -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
        -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
        -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
        -DBS_DIR_MEDIA=`pwd`/../media-driver && \
    ninja install

ENV LIBVA_DRIVER_NAME=iHD
ENV LIBVA_DRIVERS_PATH=/usr/$LIB_DIR/dri

RUN git clone https://github.com/Intel-Media-SDK/MediaSDK && \
    cd MediaSDK && \
    export MFX_HOME=`pwd` && \
    perl tools/builder/build_mfx.pl --cmake=intel64.make.release --no-warn-as-error && \
    make -j8 -C __cmake/intel64.make.release install

RUN ln -sr /opt/intel/mediasdk/lib /opt/intel/mediasdk/lib/lin_x64

ENV MFX_HOME=/opt/intel/mediasdk

RUN apt-get update && \
    apt-get install -y \
        flex bison libglib2.0-dev liborc-0.4-dev libjpeg-dev libpng-dev

RUN apt-get update && \
    apt-get install -y \
        libgudev-1.0-dev \
        libxrender-dev \
        libxrandr-dev

RUN git clone https://github.com/GStreamer/gst-build.git && \
    git -C gst-build checkout 1.14 && \
    /venv/bin/meson setup gst-build build-gstreamer
RUN ninja -C build-gstreamer install

RUN echo "/usr/local/lib/x86_64-linux-gnu" > /etc/ld.so.conf.d/local.conf && ldconfig

# ENV PKG_CONFIG_PATH=${MFX_HOME}/lib/pkgconfig

RUN git clone -b development https://github.com/ishmael1985/gstreamer-media-SDK && \
    /venv/bin/meson setup gstreamer-media-SDK build-gstreamer-media-SDK && \
    ninja -C build-gstreamer-media-SDK install


RUN useradd -u 1000 -G video -s /bin/bash test
