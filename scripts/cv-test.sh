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

export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:$LD_LIBRARY_PATH
export OPENCV_TEST_DATA_PATH=$DATADIR

$BUILDDIR/bin/opencv_test_videoio
