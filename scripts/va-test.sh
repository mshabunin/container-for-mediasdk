#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

set -x

export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:$LD_LIBRARY_PATH

# valgrind --track-origins=yes --expensive-definedness-checks=yes \
# /opt/intel/mediasdk/samples/sample_decode h264 \
#     -i /scripts/test_stream.264 \
#     -o out.yuv
#
#
# /opt/intel/mediasdk/samples/sample_encode h264 \
#     -i out.yuv \
#     -o out.h264 \
#     -w 176 -h 96
#
# /opt/intel/mediasdk/samples/sample_decode h264 \
#     -i out.h264

WORKDIR=$(pwd)
TUTORIAL_ROOT=$(find /build -type d -name 'mediasdk-tutorials-*')

if [ -n $TUTORIAL_ROOT ] ; then
    pushd $TUTORIAL_ROOT
    valgrind --track-origins=yes --expensive-definedness-checks=yes \
    ./_build/simple_session
    # ./_build/simple_decode $WORKDIR/out.h264
    #
    # ./_build/simple_encode -g 176x96 -b 5000 -f 30/1 $WORKDIR/out.yuv $WORKDIR/out-t.h264
    # ./_build/simple_transcode -b 5000 -f 30/1 $WORKDIR/out.h264 $WORKDIR/out-t.h265
    popd
fi
