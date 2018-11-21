#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib/:$LD_LIBRARY_PATH
S=/opt/intel/mediasdk/share/mfx/samples

$S/sample_decode h264 \
    -i /scripts/test_stream.264 \
    -o out.yuv

$S/sample_encode h264 \
    -i out.yuv \
    -o out.h264 \
    -w 176 -h 96

$S/sample_decode h264 \
    -i out.h264

