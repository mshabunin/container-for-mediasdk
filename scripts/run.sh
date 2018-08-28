#!/bin/bash

set -e

# gst-launch-1.0 -e  \
#     v4l2src ! \
#     image/jpeg,width=1600,height=1200,framerate=30/1 ! \
#     avimux ! \
#     filesink location=stream480.avi

# gst-launch-1.0 -e --gst-debug=fpsdisplaysink:6 \
#     filesrc location=stream1200.avi ! \
#     avidemux ! \
#     jpegparse ! \
#     mfxjpegdec ! \
#     fpsdisplaysink sync=false video-sink=fakesink text-overlay=false signal-fps-measurements=true
    # jpegdec ! \
    # filesink location=raw.stream

gst-launch-1.0 -e --gst-debug=fpsdisplaysink:6 \
    v4l2src ! \
    image/jpeg,width=1600,height=1200,framerate=10/1 ! \
    jpegparse ! \
    mfxjpegdec ! \
    mfxjpegenc ! \
    avimux ! \
    filesink location=recode.avi
    # fpsdisplaysink sync=false video-sink=fakesink text-overlay=false signal-fps-measurements=true
    # jpegdec ! \
