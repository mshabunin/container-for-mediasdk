#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

SRCDIR=/work/opencv
DATADIR=/work/opencv_extra/testdata
BUILDDIR=/work/build-opencv

export OPENCV_TEST_DATA_PATH=$DATADIR
export LIBVA_MESSAGING_LEVEL=0

#valgrind \
$BUILDDIR/bin/opencv_test_videoio \

#    --gtest_filter=*MFX*/0
    # --gtest_shuffle
    # --gtest_repeat=10

