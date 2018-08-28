#!/bin/bash

set -e

pushd build && ninja example_cpp_gstreamer_pipeline && popd

export LIBVA_MESSAGING_LEVEL=0
export GST_DEBUG_FILE=gst-debug.txt

mkdir -p test-logs

#============================================================================================

if false ; then

REP=decode-report.txt
rm -f $REP
for backend in gst-basic gst-libav gst-mfx ffmpeg ; do
for codec in h264 h265 mpeg2 mpeg4 mjpeg vp8 ; do
for container in avi mkv mp4 mov ; do

[[ $backend == gst-libav && $codec == h265 ]] && continue
LOG=test-logs/resultD-$backend-$codec-$container.txt
echo
echo "================"
echo -n "$backend / $codec / $container => " >> $REP
./build/bin/example_cpp_gstreamer_pipeline \
    -b=$backend \
    -c=$codec \
    -f=stream-$codec.$container \
    -m=decode \
    | tee $LOG
echo
( grep 'frames in' $LOG || echo "N/A" ) >> $REP

done
done
done
# rm resultD-*.txt

fi

#============================================================================================

if true ; then

REP=encode-report.txt
rm -f $REP
# gst-basic gst-libav ffmpeg
for backend in  gst-mfx  ; do
for codec in h264 h265 mpeg2 mpeg4 mjpeg vp8 ; do
for container in avi mkv mp4 mov ; do

[[ $backend == gst-basic && $codec == h264 && $container == mp4 ]] && continue
[[ $backend == gst-basic && $codec == mpeg2 && $container == mp4 ]] && continue
[[ $backend == gst-basic && $codec == mpeg2 && $container == mov ]] && continue
[[ $backend == gst-basic && $codec == h264 && $container == mkv ]] && continue
LOG=test-logs/resultE-$backend-$codec-$container.txt
echo
echo "================"
echo -n "$backend / $codec / $container => " >> $REP
./build/bin/example_cpp_gstreamer_pipeline \
    -b=$backend \
    -c=$codec \
    -f=dummy.$container \
    -m=encode \
    -fps=30 \
    -r=720p \
    | tee $LOG
echo
( grep 'frames in' $LOG || echo "N/A" ) >> $REP

done
done
done
# rm resultE-*.txt

fi
