#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

BUILDDIR=/build

pushd $BUILDDIR
c++ /scripts/test.cpp -o test \
    -Iinstall/include/opencv4 \
    -Linstall/lib \
    -lopencv_core \
    -lopencv_videoio

export LD_LIBRARY_PATH=lib:$LD_LIBRARY_PATH
./test
popd
