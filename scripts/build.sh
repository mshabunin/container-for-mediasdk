#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

set -x

SRCDIR=/opencv
DATADIR=/opencv_extra/testdata
BUILDDIR=/build

mkdir -p $BUILDDIR
pushd $BUILDDIR && rm -rf *
cmake \
    -GNinja \
    -DWITH_MFX=ON \
    -DBUILD_LIST=videoio,ts \
    -DWITH_WEBP=OFF \
    -DWITH_PNG=OFF \
    -DWITH_TIFF=OFF \
    -DWITH_JASPER=OFF \
    -DWITH_OPENEXR=OFF \
    -DVIDEOIO_PLUGIN_LIST=mfx \
    -DMFX_HOME=/opt/intel/mediasdk \
    -DMFX_INCLUDE=/opt/intel/mediasdk/include/mfx \
    -DMFX_LIBRARY=/opt/intel/mediasdk/lib/libmfx.so \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=install \
    $SRCDIR
ninja install
popd
