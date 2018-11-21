#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

set -x

SRCDIR=/work/opencv
DATADIR=/work/opencv_extra/testdata
BUILDDIR=/work/build-opencv

# export MFX_HOME=/opt/intel/mediasdk
# -DCMAKE_CXX_FLAGS="-fsanitize=address" \
# -DCMAKE_C_FLAGS="-fsanitize=address" \

mkdir -p $BUILDDIR
pushd $BUILDDIR && rm -rf *
cmake \
    -DWITH_MFX=ON \
    -DMFX_INCLUDE=/opt/intel/mediasdk/include \
    -DMFX_LIBRARY=/opt/intel/mediasdk/lib/libmfx.so \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=install \
    $SRCDIR
# make -j8 install
make -j8 opencv_test_videoio
popd
