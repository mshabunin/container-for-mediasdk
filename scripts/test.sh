#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

SRCDIR=/opencv
DATADIR=/opencv_extra/testdata
BUILDDIR=/build

export OPENCV_TEST_DATA_PATH=$DATADIR
# export OPENCV_VIDEOIO_DEBUG=1
# export OPENCV_LOG_LEVEL=INFO
export LIBVA_MESSAGING_LEVEL=0

pushd $BUILDDIR
./bin/opencv_test_videoio
popd
