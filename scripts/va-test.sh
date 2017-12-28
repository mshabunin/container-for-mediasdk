#!/bin/bash

set -x
set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:$LD_LIBRARY_PATH

vainfo

/opt/intel/mediasdk/samples/sample_decode h264 \
    -i /scripts/test_stream.264

/opt/intel/mediasdk/samples/sample_encode h264 \
    -i /scripts/test_stream_176x96.yuv \
    -o out.h264 \
    -w 176 -h 96

/opt/intel/mediasdk/samples/sample_decode h264 \
    -i out.h264
