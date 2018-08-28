#!/bin/bash

set -e

[[ ! -d libva ]] && git clone https://github.com/01org/libva

pushd libva && git clean -dfx
./autogen.sh
./configure --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
make -j8 install
popd

[[ ! -d media-driver ]] && git clone https://github.com/intel/media-driver
[[ ! -d gmmlib ]] && git clone https://github.com/intel/gmmlib

mkdir -p build-media-driver && pushd build-media-driver && rm -rf *
cmake ../media-driver \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu \
    -DLIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri \
    -DMEDIA_VERSION="2.0.0" \
    -DBUILD_ALONG_WITH_CMRTLIB=1 \
    -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
    -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
    -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
    -DBS_DIR_MEDIA=`pwd`/../media-driver
make -j8 install
popd

export LIBVA_DRIVER_NAME=iHD
export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri

[[ ! -d MediaSDK ]] && git clone https://github.com/Intel-Media-SDK/MediaSDK

pushd MediaSDK && git clean -dfx
export MFX_HOME=`pwd`
perl tools/builder/build_mfx.pl --cmake=intel64.make.release --no-warn-as-error
make -j8 -C __cmake/intel64.make.release install
popd


export MFX_HOME=/opt/intel/mediasdk

[[ ! -d gstreamer-media-SDK ]] && git clone https://github.com/intel/gstreamer-media-SDK

mkdir -p build-gst-media-SDK && pushd build-gst-media-SDK && rm -rf *
PKG_CONFIG_PATH=${MFX_HOME}/lib/pkgconfig cmake ../gstreamer-media-SDK
make install
popd
