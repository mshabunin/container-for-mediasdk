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
    -DCMAKE_BUILD_TYPE=Debug \
    $SRCDIR
make -j8 opencv_test_videoio
popd
