#!/bin/bash

set -x
set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

SRCDIR=/work/opencv
DATADIR=/work/opencv_extra/testdata
BUILDDIR=/work/build-opencv

export MFX_HOME=/opt/intel/mediasdk
# export LIBVA_DRIVER_NAME=i965

mkdir -p $BUILDDIR
pushd $BUILDDIR && rm -rf *
cmake -DWITH_MFX=ON $SRCDIR
make -j8
popd
