#!/bin/bash

set -e

src=stream1200.avi

# gen SUFFIX [ffmpeg parameters]
gen() {
    SUF=$1
    shift 1
    for c in mp4 avi mkv mov ; do
        [[ $c == mp4 && $SUF == vp8 ]] && continue
        ffmpeg -y -i $src -an $@ stream-$SUF.$c
    done
}

gen vp8 -vcodec libvpx &
gen h265 -vcodec libx265 -pix_fmt yuv420p -preset veryfast &
gen mpeg2 -vcodec mpeg2video -pix_fmt yuv420p &
gen mpeg4 -vcodec mpeg4 -pix_fmt yuv420p &
gen mjpeg -vcodec mjpeg &
gen h264 -vcodec libx264 -pix_fmt yuv420p &

wait
